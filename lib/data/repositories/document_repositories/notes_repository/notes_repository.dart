import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/app_constants.dart';
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

  Future<ApiResponse> _deleteNotesFromStorage({
    required String course, required int semester,
    required String subject, required String noteId,
  }) async {
    try {
      await _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('notes')
          .child("$noteId.pdf").delete();

      return ApiResponse.success();
    } on storage.FirebaseException catch (_) {
      return ApiResponse.error(errorMessage: "Couldn't delete notes from storage");
    }
  }

  Future<ApiResponse> _uploadNotesToStorage({
    required File document,
    required String course, required int semester,
    required String subject, required String noteId,
  }) async {
    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('notes')
          .child("$noteId.pdf");

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>.success(data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse.error(errorMessage: "Couldn't upload notes to storage");
    }
  }

  Future<ApiResponse> deleteNote({
    required String course, required int semester,
    required String subject, required String noteId,
  }) async {
    try {
      firestore.DocumentSnapshot notesSnapshot = await coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.notesCollectionLabel).doc(noteId).get();

      await notesSnapshot.reference.delete();

      ApiResponse deleteResponse = await _deleteNotesFromStorage(course: course, semester: semester, subject: subject, noteId: noteId);
      if (deleteResponse.isError) {
        return deleteResponse;
      }

      return ApiResponse.success();

    } on Exception catch (e) {
      return ApiResponse.error(errorMessage: "There was an error while deleting notes");
    }
  }

  Future<ApiResponse> uploadAndAddNotes({
    required String course, required int semester,
    required String subject, required UserModel user,
    required File document, required String title,
    required String description,
    required maxNotesPerSubject,
  }) async {

    try {
      firestore.CollectionReference notesCollection = coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.notesCollectionLabel);

      firestore.QuerySnapshot notesSnapshot = await notesCollection.get();

      if (notesSnapshot.docs.length >= maxNotesPerSubject) {
        return ApiResponse.error(errorMessage: "The subject $subject has maximum notes. So you cannot upload.");
      }

      firestore.DocumentReference noteRef = await notesCollection.add(NotesModel.toFirestoreMap(
          documentUrl: null, user: user, title: title, description: description
      ));

      ApiResponse uploadResponse = await _uploadNotesToStorage(
        document: document, course: course, semester: semester, subject: subject,
        noteId: noteRef.id,
      );

      if (uploadResponse.isError) {
        await noteRef.delete();
        return uploadResponse;
      } else {
        String documentUrl = uploadResponse.data;
        await noteRef.update({
          NotesModel.documentUrlFieldKey: documentUrl,
        });
        return ApiResponse.success();
      }
    } catch (err) {
      return ApiResponse.error(errorMessage: "There was an error while setting notes: $err");
    }
  }

  Future<ApiResponse> reportNotes({
    required String course, required int semester,
    required String subject, required String userId,
    required String noteId, required List<String> reportValues,
  }) async {
    try {
      firestore.DocumentSnapshot notesSnapshot = await coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.notesCollectionLabel).doc(noteId).get();

      Map<String, dynamic> notesData = notesSnapshot.data() as Map<String, dynamic>;

      List<String> reports = [];
      if (notesData.containsKey(FirebaseCollectionConfig.reportsFieldLabel) && notesData[FirebaseCollectionConfig.reportsFieldLabel][userId] != null) {
        reports = List<String>.from(notesData[FirebaseCollectionConfig.reportsFieldLabel][userId]);
        reports.addAll(reportValues);
        reports = reports.toSet().toList();
      } else {
        reports = reportValues;
      }
      notesSnapshot.reference.update({
        "${FirebaseCollectionConfig.reportsFieldLabel}.$userId" : reports,
      });
      return ApiResponse.success();
    } on Exception catch (e) {
      return ApiResponse.error(errorMessage: "There was an error while reporting notes");
    }


  }

  Future<ApiResponse> addRatingToNotes({
    required String noteId, required double rating, required UserModel user,
    required String course, required int semester, required String subject,
  }) async {

    try {

      firestore.DocumentSnapshot starsSnapshot = await coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.notesCollectionLabel).doc(noteId)
          .collection(FirebaseCollectionConfig.starsCollectionLabel).doc(user.uid).get();

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

  Future<ApiResponse> addRatingToUser({
    required String ratingAcceptedUserId, required double rating,
    required String noteId, required String ratingGivenUserId,
  }) async {
    try {
      firestore.DocumentSnapshot ratingSnapshot = await _firebaseFirestore.collection(FirebaseCollectionConfig.usersCollectionLabel)
          .doc(ratingAcceptedUserId)
          .collection(FirebaseCollectionConfig.ratingCollectionLabel).doc(noteId).get();

      if(ratingSnapshot.exists) {
        await ratingSnapshot.reference.update({
          ratingGivenUserId : {"rating": rating,},
        });

      } else {
        await ratingSnapshot.reference.set({
          ratingGivenUserId : {"rating": rating,},
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

      firestore.QuerySnapshot notesSnapshot = await coursesCollection.doc(course)
          .collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString())
          .collection(FirebaseCollectionConfig.subjectsCollectionLabel).doc(subject)
          .collection(FirebaseCollectionConfig.notesCollectionLabel).get();

      List<NotesModel> notes = [];
      await Future.forEach<firestore.QueryDocumentSnapshot>(notesSnapshot.docs ,(note) async {

        firestore.QuerySnapshot starsSnapshot = await note.reference.collection(FirebaseCollectionConfig.starsCollectionLabel).get();
        List<double> ratings = starsSnapshot.docs.map((e) {
          return ((e.data() as Map<String, dynamic>)['rating']) as double;
        }).toList();

        notes.add(NotesModel.fromFirestoreMap(
          map: note.data() as Map<String, dynamic>,
          avgRating: ratings.length == 0 ? 0 : ratings.average,
          notesId: note.id,
        ));
      });
      return ApiResponse<List<NotesModel>>.success(data: notes);
    } catch (e) {
      print("ERR: $e");
      return ApiResponse.error(errorMessage: "Error while fetching notes");
    }
  }
  
}