import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/text_book.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class TextBookRepository {
  final firestore.FirebaseFirestore _firebaseFirestore;
  final storage.FirebaseStorage _firebaseStorage;

  TextBookRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    _coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
    _textBookUploadsAdminCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.adminTextBookUploadsCollectionLabel);
  }

  static late final firestore.CollectionReference _coursesCollection;
  static late final firestore.CollectionReference _textBookUploadsAdminCollection;


  Future<ApiResponse> _uploadTextBook({
    required File document,
    required String course, required int semester,
    required String subject, required String textBookId,
  }) async {
    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('text_book')
          .child("$textBookId.pdf");

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>.success(data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse.error(errorMessage: "Couldn't upload text book to storage");
    }
  }

  Future<ApiResponse> uploadAndAddTextBookToAdmin({
    required String course, required int semester,
    required String subject, required UserModel user,
    required File document,
    required int maxTextBooks
  }) async {
    try {


      Map<String, dynamic> textBookDetails = TextBookModel.toFirestoreMap(user: user,);
      textBookDetails.addAll({
        "course": course,
        "semester": semester,
        "subject": subject,
      });
      firestore.DocumentReference textBookRef = await _textBookUploadsAdminCollection.add(textBookDetails);

      ApiResponse uploadResponse = await _uploadTextBook(
          document: document, course: course,
          semester: semester, subject: subject, textBookId: textBookRef.id,
      );

      if (uploadResponse.isError) {
        await textBookRef.delete();
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;
      textBookRef.update({
        TextBookModel.documentUrlFieldKey: documentUrl,
      });
      return ApiResponse.success();

    } catch (err) {
      return ApiResponse.error(errorMessage: "There was an error while setting question paper: $err");
    }

  }


  // Future<ApiResponse> uploadAndAddTextBook({
  //   required String course, required int semester,
  //   required String subject, required UserModel user,
  //   required int version, required File document,
  //   required int maxTextBooks
  // }) async {
  //   try {
  //     firestore.CollectionReference textBookCollectionReference = _coursesCollection.doc(course)
  //         .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
  //         .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
  //         .collection(FirebaseCollectionConfig.textBookCollectionLabel);
  //     firestore.QuerySnapshot journalSnapshot = await textBookCollectionReference.get();
  //
  //     if (journalSnapshot.docs.length >= maxTextBooks) {
  //       return ApiResponse.error(errorMessage: "The subject : ${subject} has maximum versions. Please refresh to view them");
  //     }
  //
  //     ApiResponse uploadResponse = await _uploadTextBook(document: document, course: course, semester: semester, subject: subject, version: version);
  //
  //     if (uploadResponse.isError) {
  //       return uploadResponse;
  //     }
  //
  //     String documentUrl = uploadResponse.data;
  //     await textBookCollectionReference.doc(version.toString()).set(TextBookModel.toFirestoreMap(documentUrl: documentUrl, user: user));
  //
  //     return ApiResponse.success();
  //
  //   } catch (err) {
  //     return ApiResponse.error(errorMessage: "There was an error while setting question paper: $err");
  //   }
  //
  // }


  Future<ApiResponse> getTextBook({
    required String course, required int semester,
  }) async {
    try {

      firestore.QuerySnapshot subjectSnapshot = await _coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();

      List<TextBookSubjectModel> textBookSubjects = [];
      await Future.forEach<firestore.QueryDocumentSnapshot>(subjectSnapshot.docs, (subject) async {

        List<TextBookModel> textBooks = [];
        firestore.QuerySnapshot journalSnapshot = await subject.reference.collection(FirebaseCollectionConfig.textBookCollectionLabel).get();
        await Future.forEach<firestore.QueryDocumentSnapshot>(journalSnapshot.docs, (journal) {
          Map<String, dynamic> journalData = journal.data() as Map<String, dynamic>;
          textBooks.add(TextBookModel.fromFirestoreMap(map: journalData, id: journal.id));
        });

        textBookSubjects.add(TextBookSubjectModel(
          subject: subject.id,
          textBookModels: textBooks,
        ));
      });
      return ApiResponse<List<TextBookSubjectModel>>.success(data: textBookSubjects);
    } catch (_) {
      return ApiResponse.error(errorMessage: "Error while fetching textBooks");
    }
  }

  Future<ApiResponse> reportTextBook({
    required String course, required int semester,
    required String subject, required String userId,
    required String textBookId, required List<String> reportValues,
  }) async {
    try {
      firestore.DocumentSnapshot versionSnapshot = await _coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.textBookCollectionLabel).doc(textBookId).get();

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
      return ApiResponse.error(errorMessage: "There was an error while reporting text book");
    }

  }

}