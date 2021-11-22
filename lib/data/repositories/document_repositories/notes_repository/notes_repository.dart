import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/notes_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class NotesRepository {

  final firestore.FirebaseFirestore _firebaseFirestore;
  final storage.FirebaseStorage _firebaseStorage;
  static late final firestore.CollectionReference coursesCollection;

  NotesRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  Future<ApiResponse> uploadNotes({
    required File document,
    required String course, required int semester,
    required String subject,
  }) async {
    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('notes')
          .child(document.path.split("/").last);

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>(isError: false, data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse(isError: false, errorMessage: "Couldn't upload notes to storage");
    }
  }


  Future<ApiResponse> uploadAndAddNotes({
    required String course, required int semester,
    required String subject, required UserModel user,
    required File document, required String title,
    required String description,
  }) async {

    try {
      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();

      firestore.CollectionReference notesCollection = subjectSnapshot.reference.collection(FirebaseCollectionConfig.notesCollectionLabel);
      ApiResponse uploadResponse = await uploadNotes(document: document, course: course, semester: semester, subject: subject);

      if (uploadResponse.isError) {
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;
      await notesCollection.doc().set({
        "document_url": documentUrl,
        "uploaded_by": user.displayName,
        "title": title,
        "description": description,
        "uploaded_on": DateTime.now(),
        "rating": 0.0,
        "user_email": user.email,
        "user_profile_photo_url": user.photoUrl,
        "user_uid": user.uid,
      });
      return ApiResponse(isError: false,);
    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "There was an error while setting notes: $err");
    }
  }

  Future<ApiResponse> getNotes({
    required String course, required int semester,
    required String subject,
  }) async {
    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();
      firestore.QuerySnapshot notesSnapshot = await subjectSnapshot.reference.collection(FirebaseCollectionConfig.notesCollectionLabel).get();

      List<NotesModel> notes = [];
      notesSnapshot.docs.forEach((note) {
        notes.add(NotesModel.fromFirestoreMap(note.data() as Map<String, dynamic>));
      });
      return ApiResponse<List<NotesModel>>(isError: false, data: notes);
    } catch (_) {
      return ApiResponse(isError: true, errorMessage: "Error while fetching journals");
    }
  }


}