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
      return ApiResponse<String>.success(data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse.error(errorMessage: "Couldn't upload text book to storage");
    }
  }


  Future<ApiResponse> uploadAndAddTextBook({
    required String course, required int semester,
    required String subject, required UserModel user,
    required int version, required File document,
  }) async {
    try {
      firestore.CollectionReference textBookCollectionReference = coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.textBookCollectionLabel);
      firestore.QuerySnapshot journalSnapshot = await textBookCollectionReference.get();

      if (journalSnapshot.docs.length >= AppConstants.maxTextBooks) {
        return ApiResponse.error(errorMessage: "The subject : ${subject} has maximum versions. Please refresh to view them");
      }

      ApiResponse uploadResponse = await uploadTextBook(document: document, course: course, semester: semester, subject: subject, version: version);

      if (uploadResponse.isError) {
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;
      await textBookCollectionReference.doc(version.toString()).set(TextBookModel.toFirestoreMap(documentUrl: documentUrl, user: user));

      return ApiResponse.success();

    } catch (err) {
      return ApiResponse.error(errorMessage: "There was an error while setting question paper: $err");
    }

  }


  Future<ApiResponse> getTextBook({
    required String course, required int semester,
  }) async {
    try {

      firestore.QuerySnapshot subjectSnapshot = await coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();

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
      return ApiResponse<List<TextBookSubjectModel>>.success(data: textBookSubjects);
    } catch (_) {
      return ApiResponse.error(errorMessage: "Error while fetching textBooks");
    }
  }

  Future<ApiResponse> reportTextBook({
    required String course, required int semester,
    required String subject, required String userId,
    required int version, required List<String> reportValues,
  }) async {
    try {
      firestore.DocumentSnapshot versionSnapshot = await coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.textBookCollectionLabel).doc(version.toString()).get();

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