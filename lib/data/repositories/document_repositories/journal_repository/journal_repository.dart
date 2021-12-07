import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/journal_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class JournalRepository {
  final firestore.FirebaseFirestore _firebaseFirestore;
  final storage.FirebaseStorage _firebaseStorage;

  JournalRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    _coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
    _journalUploadsAdminCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.adminJournalUploadsCollectionLabel);
  }

  static late final firestore.CollectionReference _coursesCollection;
  static late final firestore.CollectionReference _journalUploadsAdminCollection;

  Future<ApiResponse> _uploadJournal({
    required File document,
    required String course, required int semester,
    required String subject, required int version,
  }) async {
    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('journals')
          .child("$version.pdf");

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>.success(data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse.error(errorMessage: "Couldn't upload journal to storage");
    }
  }


  // Future<ApiResponse> uploadAndAddJournal({
  //   required String course, required int semester,
  //   required String subject, required UserModel user,
  //   required int version, required File document,
  //   required int maxJournals,
  // }) async {
  //   try {
  //     firestore.CollectionReference journalCollectionReference = _coursesCollection.doc(course)
  //         .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
  //         .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
  //         .collection(FirebaseCollectionConfig.journalCollectionLabel);
  //
  //     firestore.QuerySnapshot journalSnapshot = await journalCollectionReference.get();
  //
  //     if (journalSnapshot.docs.length >= maxJournals) {
  //       return ApiResponse.error(errorMessage: "The subject : ${subject} has maximum versions. Please refresh to view them");
  //     }
  //
  //     ApiResponse uploadResponse = await _uploadJournal(
  //       document: document, course: course, semester: semester,
  //       subject: subject, version: version,
  //     );
  //
  //     if (uploadResponse.isError) {
  //       return uploadResponse;
  //     }
  //
  //     String documentUrl = uploadResponse.data;
  //     await journalCollectionReference.doc(version.toString()).set(JournalModel.toFirestoreMap(
  //         user: user, documentUrl: documentUrl
  //     ));
  //
  //     return ApiResponse.success();
  //
  //   } catch (err) {
  //     return ApiResponse.error(errorMessage: "There was an error while setting question paper: $err");
  //   }
  //
  // }







  Future<ApiResponse> uploadAndAddJournalToAdmin({
    required String course, required int semester,
    required String subject, required UserModel user,
    required int version, required File document,
    required int maxJournals,
  }) async {
    try {
      ApiResponse uploadResponse = await _uploadJournal(
        document: document, course: course, semester: semester,
        subject: subject, version: version,
      );

      if (uploadResponse.isError) {
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;

      Map<String, dynamic> journalDetails = JournalModel.toFirestoreMap(user: user, documentUrl: documentUrl);
      journalDetails.addAll({
        "course": course,
        "semester": semester,
        "subject": subject,
        "version": version,
      });
      await _journalUploadsAdminCollection.add(journalDetails);

      return ApiResponse.success();

    } catch (err) {
      return ApiResponse.error(errorMessage: "There was an error while setting question paper: $err");
    }

  }




  Future<ApiResponse> getJournals({
    required String course, required int semester,
  }) async {
    try {

      firestore.QuerySnapshot subjectSnapshot = await _coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();

      List<JournalSubjectModel> journalSubjects = [];
      await Future.forEach<firestore.QueryDocumentSnapshot>(subjectSnapshot.docs, (subject) async {

        List<JournalModel> journals = [];
        firestore.QuerySnapshot journalSnapshot = await subject.reference.collection(FirebaseCollectionConfig.journalCollectionLabel).get();
        await Future.forEach<firestore.QueryDocumentSnapshot>(journalSnapshot.docs, (journal) {
          Map<String, dynamic> journalData = journal.data() as Map<String, dynamic>;
          journals.add(JournalModel.fromFirestoreMap(map: journalData, version: int.parse(journal.id)));
        });

        journalSubjects.add(JournalSubjectModel(
          subject: subject.id,
          journalModels: journals,
        ));
      });
      return ApiResponse<List<JournalSubjectModel>>.success(data: journalSubjects);
    } catch (e) {
      print("ERR: $e");
      return ApiResponse.error(errorMessage: "Error while fetching journals");
    }
  }

  Future<ApiResponse> reportJournal({
    required String course, required int semester,
    required String subject, required int version,
    required List<String> reportValues, required String userId,
  }) async {
    try {
      firestore.DocumentSnapshot versionSnapshot = await _coursesCollection.doc(course)
        .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
        .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
        .collection(FirebaseCollectionConfig.journalCollectionLabel).doc(version.toString()).get();

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
      return ApiResponse.error(errorMessage: "There was an error while reporting journal");
    }

  }

}