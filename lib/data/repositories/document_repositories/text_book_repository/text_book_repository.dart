import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/text_book.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class TextBookRepository {
  final firestore.FirebaseFirestore _firebaseFirestore;
  final storage.FirebaseStorage _firebaseStorage;
  static late final firestore.CollectionReference coursesCollection;

  TextBookRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  Future<ApiResponse> uploadTextBook({
    required File document,
    required String course, required int semester,
    required String subject, required int version,
  }) async {
    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('text_book')
          .child("$version.pdf");

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>(isError: false, data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse(isError: false, errorMessage: "Couldn't upload text book to storage");
    }
  }


  Future<ApiResponse> uploadAndAddTextBook({
    required String course, required int semester,
    required String subject, required UserModel user,
    required int version, required File document,
  }) async {
    try {
      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();

      firestore.CollectionReference textBookCollectionReference = subjectSnapshot.reference.collection(FirebaseCollectionConfig.textBookCollectionLabel);
      firestore.QuerySnapshot journalSnapshot = await textBookCollectionReference.get();

      if (journalSnapshot.docs.length >= AppConstants.maxTextBooks) {
        return ApiResponse(isError: true, errorMessage: "The subject : ${subject} has maximum versions. Please refresh to view them");
      }

      ApiResponse uploadResponse = await uploadTextBook(document: document, course: course, semester: semester, subject: subject, version: version);

      if (uploadResponse.isError) {
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;
      await textBookCollectionReference.doc(version.toString()).set(
          {
            "uploaded_by": user.displayName,
            "document_url": documentUrl,
            "uploaded_on": DateTime.now(),
            "user_profile_photo_url": user.photoUrl,
            "user_email": user.email,
            "user_uid": user.uid,
          }
      );

      // firestore.DocumentSnapshot yearSnapshot = await subjectSnapshot.reference.collection(FirebaseCollectionConfig.questionPaperCollectionLabel).doc(year.toString()).get();
      // firestore.CollectionReference versionCollectionReference = yearSnapshot.reference.collection(FirebaseCollectionConfig.versionsCollectionLabel);
      // firestore.QuerySnapshot versionSnapshot = await versionCollectionReference.get();

      // if (versionSnapshot.docs.length >= AppConstants.maxQuestionPapers) {
      //   return ApiResponse(isError: true, errorMessage: "The year $year has maximum versions. Please refresh to view them");
      // }

      // ApiResponse uploadResponse = await uploadQuestionPaper(document: document, year: year, course: course, semester: semester, subject: subject, version: version);
      //
      // if (uploadResponse.isError) {
      //   return uploadResponse;
      // }

      // String documentUrl = uploadResponse.data;
      // await versionCollectionReference.doc(version.toString()).set(
      //     {
      //       "uploaded_by": user.displayName,
      //       "url": documentUrl,
      //     }
      // );
      return ApiResponse(isError: false,);

    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "There was an error while setting question paper: $err");
    }

  }


  Future<ApiResponse> getTextBook({
    required String course, required int semester,
  }) async {
    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();

      firestore.QuerySnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();

      List<TextBookSubjectModel> textBookSubjects = [];
      await Future.forEach<firestore.QueryDocumentSnapshot>(subjectSnapshot.docs, (subject) async {

        List<TextBookModel> textBooks = [];
        firestore.QuerySnapshot journalSnapshot = await subject.reference.collection(FirebaseCollectionConfig.textBookCollectionLabel).get();
        await Future.forEach<firestore.QueryDocumentSnapshot>(journalSnapshot.docs, (journal) {
          Map<String, dynamic> journalData = journal.data() as Map<String, dynamic>;
          textBooks.add(TextBookModel.fromFirestoreMap(map: journalData, version: int.parse(journal.id)));
        });

        textBookSubjects.add(TextBookSubjectModel(
          subject: subject.id,
          textBookModels: textBooks,
        ));
      });
      return ApiResponse<List<TextBookSubjectModel>>(isError: false, data: textBookSubjects);
    } catch (_) {
      return ApiResponse(isError: true, errorMessage: "Error while fetching textBooks");
    }
  }

}