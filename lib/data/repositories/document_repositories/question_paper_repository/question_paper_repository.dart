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

  QuestionPaperRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    _coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
    _questionPaperUploadsCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.adminQuestionPaperUploadsCollectionLabel);
  }

  static late final firestore.CollectionReference _coursesCollection;
  static late final firestore.CollectionReference _questionPaperUploadsCollection;

  Future<ApiResponse> _uploadQuestionPaper({
    required File document, required int year,
    required String course, required int semester,
    required String subject, required String questionPaperId,
  }) async {
    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('question_paper')
          .child(year.toString()).child("$questionPaperId.pdf");

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>.success(data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse.error(errorMessage: "Couldn't upload question paper to storage");
    }
  }

  Future<ApiResponse> uploadAndAddQuestionPaperToAdmin({
    required String course, required int semester,
    required String subject, required UserModel user,
    required int version, required int year, required File document,
    required int maxQuestionPapers
  }) async {

    try {
      Map<String, dynamic> journalDetails = QuestionPaperModel.toFirestoreMap(user: user, version: version);
      journalDetails.addAll({
        "course": course,
        "semester": semester,
        "subject": subject,
        "year": year,
      });
      firestore.DocumentReference questionPaperRef = await _questionPaperUploadsCollection.add(journalDetails);

      ApiResponse uploadResponse = await _uploadQuestionPaper(
        document: document, year: year, course: course,
        semester: semester, subject: subject, questionPaperId: questionPaperRef.id,
      );

      if (uploadResponse.isError) {
        await questionPaperRef.delete();
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;
      questionPaperRef.update({
        QuestionPaperModel.documentUrlFieldKey: documentUrl,
      });

      return ApiResponse.success();
    } on Exception catch (e) {
      return ApiResponse.error(errorMessage: "There was an error while uploading question paper");

    }

  }




  // Future<ApiResponse> uploadAndAddQuestionPaper({
  //   required String course, required int semester,
  //   required String subject, required UserModel user,
  //   required int version, required int year, required File document,
  //   required int maxQuestionPapers
  // }) async {
  //   try {
  //     firestore.CollectionReference versionCollectionReference = _coursesCollection.doc(course)
  //         .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
  //         .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
  //         .collection(FirebaseCollectionConfig.questionPaperCollectionLabel).doc(year.toString())
  //         .collection(FirebaseCollectionConfig.versionsCollectionLabel);
  //     firestore.QuerySnapshot versionSnapshot = await versionCollectionReference.get();
  //
  //     if (versionSnapshot.docs.length >= maxQuestionPapers) {
  //       return ApiResponse.error(errorMessage: "The year $year has maximum versions. Please refresh to view them");
  //     }
  //
  //     ApiResponse uploadResponse = await _uploadQuestionPaper(document: document, year: year, course: course, semester: semester, subject: subject, version: version);
  //
  //     if (uploadResponse.isError) {
  //       return uploadResponse;
  //     }
  //
  //     String documentUrl = uploadResponse.data;
  //     await versionCollectionReference.doc(version.toString()).set(QuestionPaperModel.toFirestoreMap(
  //       user: user, documentUrl: documentUrl,
  //     ));
  //     return ApiResponse.success();
  //
  //   } catch (err) {
  //     return ApiResponse.error(errorMessage: "There was an error while setting question paper: $err");
  //   }
  //
  // }

  Future<ApiResponse> getQuestionPapers({
    required String course, required int semester,
    required String subject,
  }) async {
    try {

      firestore.QuerySnapshot questionPaperSnapshot = await _coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.questionPaperCollectionLabel).get();

      List<QuestionPaperYearModel> questionPaperYears = [];

      await Future.forEach<firestore.QueryDocumentSnapshot>(questionPaperSnapshot.docs, (questionPaper) async {
        firestore.QuerySnapshot versionsSnapshot = await questionPaper.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel).get();
        List<QuestionPaperModel> questionPapers = [];

        await Future.forEach<firestore.QueryDocumentSnapshot>(versionsSnapshot.docs, (version) async {
          Map<String, dynamic> versionData = version.data() as Map<String, dynamic>;
          print("CHECK: ${versionData}");
          questionPapers.add(QuestionPaperModel.fromFirestoreMap(map: versionData, id: version.id));
        });
        questionPaperYears.add(QuestionPaperYearModel(
          year: int.parse(questionPaper.id),
          questionPaperModels: questionPapers,
        ));
      });
      return ApiResponse<List<QuestionPaperYearModel>>.success(data: questionPaperYears);
    } catch (_) {
      return ApiResponse.error(errorMessage: "Error while fetching question papers");
    }
  }

  Future<ApiResponse> reportQuestionPaper({
    required String course, required int semester,
    required String subject, required int year,
    required int nVersion, required List<String> reportValues,
    required String userId,
  }) async {

    try {
      firestore.DocumentSnapshot versionSnapshot = await _coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.questionPaperCollectionLabel).doc(year.toString())
          .collection(FirebaseCollectionConfig.versionsCollectionLabel).doc(nVersion.toString()).get();

      Map<String, dynamic> versionData = versionSnapshot.data() as Map<String, dynamic>;

      List<String> reports = [];
      if (versionData.containsKey(FirebaseCollectionConfig.reportsFieldLabel) && versionData[FirebaseCollectionConfig.reportsFieldLabel][userId] != null) {
        reports = List<String>.from(versionData[FirebaseCollectionConfig.reportsFieldLabel][userId]);
        reports.addAll(reportValues);
        reports = reports.toSet().toList();
      } else {
        reports = reportValues;
      }
      versionSnapshot.reference.update({
        "${FirebaseCollectionConfig.reportsFieldLabel}.$userId" : reports,
      });
      return ApiResponse.success();
    } on Exception catch (e) {
      return ApiResponse.error(errorMessage: "There was some error while reporting the document");
    }


  }

}