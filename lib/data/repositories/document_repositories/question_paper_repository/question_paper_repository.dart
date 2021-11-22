import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class QuestionPaperRepository {

  final firestore.FirebaseFirestore _firebaseFirestore;
  final storage.FirebaseStorage _firebaseStorage;
  static late final firestore.CollectionReference coursesCollection;

  QuestionPaperRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  Future<ApiResponse> uploadQuestionPaper({
    required File document, required int year,
    required String course, required int semester,
    required String subject, required int version,
  }) async {
    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('question_paper')
          .child(year.toString()).child("$version.pdf");

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>(isError: false, data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse(isError: false, errorMessage: "Couldn't upload question paper to storage");
    }
  }

  Future<ApiResponse> uploadAndAddQuestionPaper({
    required String course, required int semester,
    required String subject, required UserModel user,
    required int version, required int year, required File document,
  }) async {
    try {
      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();
      firestore.DocumentSnapshot yearSnapshot = await subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).doc(year.toString()).get();
      firestore.CollectionReference versionCollectionReference = yearSnapshot.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel);
      firestore.QuerySnapshot versionSnapshot = await versionCollectionReference.get();
      
      if (versionSnapshot.docs.length >= AppConstants.maxQuestionPapers) {
        return ApiResponse(isError: true, errorMessage: "The year $year has maximum versions. Please refresh to view them");
      }
      
      ApiResponse uploadResponse = await uploadQuestionPaper(document: document, year: year, course: course, semester: semester, subject: subject, version: version);
      
      if (uploadResponse.isError) {
        return uploadResponse;
      } 
      
      String documentUrl = uploadResponse.data;
      await versionCollectionReference.doc(version.toString()).set(
          {
            "uploaded_by": user.displayName,
            "url": documentUrl,
          }
      );
      return ApiResponse(isError: false,);

    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "There was an error while setting question paper: $err");
    }

  }

  Future<ApiResponse> getQuestionPapers({
    required String course, required int semester,
    required String subject,
  }) async {
    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();
      firestore.QuerySnapshot questionPaperSnapshot = await subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).get();
      List<QuestionPaperYearModel> questionPaperYears = [];

      await Future.forEach<firestore.QueryDocumentSnapshot>(questionPaperSnapshot.docs, (questionPaper) async {
        firestore.QuerySnapshot versionsSnapshot = await questionPaper.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).get();
        List<QuestionPaperModel> questionPapers = [];

        await Future.forEach<firestore.QueryDocumentSnapshot>(versionsSnapshot.docs, (version) async {
          Map<String, dynamic> versionData = version.data() as Map<String, dynamic>;
          questionPapers.add(QuestionPaperModel(
            version: int.parse(version.id),
            uploadedBy: versionData['uploaded_by'],
            url: versionData['url'],
          ));
        });
        questionPaperYears.add(QuestionPaperYearModel(
          year: int.parse(questionPaper.id),
          questionPaperModels: questionPapers,
        ));
      });
      return ApiResponse<List<QuestionPaperYearModel>>(isError: false, data: questionPaperYears);
    } catch (_) {
      return ApiResponse(isError: true, errorMessage: "Error while fetching question papers");
    }
  }

}