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
  static late final firestore.CollectionReference coursesCollection;

  JournalRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  Future<ApiResponse> uploadJournal({
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
      return ApiResponse<String>(isError: false, data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse(isError: false, errorMessage: "Couldn't upload journal to storage");
    }
  }


  Future<ApiResponse> uploadAndAddJournal({
    required String course, required int semester,
    required String subject, required UserModel user,
    required int version, required File document,
  }) async {
    try {
      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();

      firestore.CollectionReference subjectCollectionReference = subjectSnapshot.reference.collection(FirebaseCollectionConfig.journalCollectionLabel);
      firestore.QuerySnapshot journalSnapshot = await subjectCollectionReference.get();

      if (journalSnapshot.docs.length >= AppConstants.maxJournals) {
        return ApiResponse(isError: true, errorMessage: "The subject : ${subject} has maximum versions. Please refresh to view them");
      }

      ApiResponse uploadResponse = await uploadJournal(document: document, course: course, semester: semester, subject: subject, version: version);

      if (uploadResponse.isError) {
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;
      await subjectCollectionReference.doc(version.toString()).set(
          {
            "uploaded_by": user.displayName,
            "url": documentUrl,
            "uploaded_on": DateTime.now(),
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


  Future<ApiResponse> getJournals({
    required String course, required int semester,
  }) async {
    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();

      firestore.QuerySnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).get();

      List<JournalSubjectModel> journalSubjects = [];
      await Future.forEach<firestore.QueryDocumentSnapshot>(subjectSnapshot.docs, (subject) async {

        List<JournalModel> journals = [];
        firestore.QuerySnapshot journalSnapshot = await subject.reference.collection(FirebaseCollectionConfig.journalCollectionLabel).get();
        await Future.forEach<firestore.QueryDocumentSnapshot>(journalSnapshot.docs, (journal) {
          Map<String, dynamic> journalData = journal.data() as Map<String, dynamic>;
          journals.add(JournalModel(
            uploadedOn: DateTime.now(), // todo change to database value
            version: int.parse(journal.id),
            uploadedBy: journalData['uploaded_by'],
            url: journalData['url'],
          ));
        });

        journalSubjects.add(JournalSubjectModel(
          subject: subject.id,
          journalModels: journals,
        ));
      });
      return ApiResponse<List<JournalSubjectModel>>(isError: false, data: journalSubjects);
    } catch (_) {
      return ApiResponse(isError: true, errorMessage: "Error while fetching journals");
    }
  }

}