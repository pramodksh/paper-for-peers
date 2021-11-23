import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:collection/collection.dart';
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
      return ApiResponse<String>.success(data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse.error(errorMessage: "Couldn't upload notes to storage");
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
      await notesCollection.doc().set(NotesModel.toFirestoreMap(documentUrl: documentUrl, user: user, title: title, description: description));
      return ApiResponse.success();
    } catch (err) {
      return ApiResponse.error(errorMessage: "There was an error while setting notes: $err");
    }
  }


  Future<ApiResponse> addRatingToNotes({
    required String noteId, required double rating, required UserModel user,
    required String course, required int semester, required String subject,
  }) async {

    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.DocumentSnapshot subjectSnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject).get();
      firestore.DocumentSnapshot notesSnapshot = await subjectSnapshot.reference.collection(FirebaseCollectionConfig.notesCollectionLabel).doc(noteId).get();
      firestore.DocumentSnapshot starsSnapshot = await notesSnapshot.reference.collection(FirebaseCollectionConfig.starsCollectionLabel).doc(user.uid).get();

      if(starsSnapshot.exists) {
        await starsSnapshot.reference.update({
          'rating': rating,
        });

      } else {
        await starsSnapshot.reference.set({
          'rating': rating,
        });
      }
      return ApiResponse.success();
    } catch (e) {
      return ApiResponse.error(errorMessage: "There was some error while updating rating");
    }

  }

  Future<ApiResponse> addRatingToUser({required UserModel user, required double rating, required String noteId}) async {
    try {
      firestore.DocumentSnapshot userDocumentSnapshot = await _firebaseFirestore.collection(FirebaseCollectionConfig.usersCollectionLabel).doc(user.uid).get();
      firestore.DocumentSnapshot ratingSnapshot = await userDocumentSnapshot.reference.collection(FirebaseCollectionConfig.ratingCollectionLabel).doc(noteId).get();

      if(ratingSnapshot.exists) {
        await ratingSnapshot.reference.update({
          'rating': rating,
        });

      } else {
        await ratingSnapshot.reference.set({
          'rating': rating,
        });
      }
      return ApiResponse.success();
    } catch(e) {
      return ApiResponse.error(errorMessage: "There was an error while updating user rating");
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
      await Future.forEach<firestore.QueryDocumentSnapshot>(notesSnapshot.docs ,(note) async {

        firestore.QuerySnapshot starsSnapshot = await note.reference.collection(FirebaseCollectionConfig.starsCollectionLabel).get();
        List<double> ratings = starsSnapshot.docs.map((e) {
          return ((e.data() as Map<String, dynamic>)['rating']) as double;
        }).toList();

        notes.add(NotesModel.fromFirestoreMap(
          map: note.data() as Map<String, dynamic>,
          avgRating: ratings.average,
          notesId: note.id,
        ));
      });
      return ApiResponse<List<NotesModel>>.success(data: notes);
    } catch (_) {
      return ApiResponse.error(errorMessage: "Error while fetching journals");
    }
  }
  
}