import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/config/firebase_collection_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/syllabus_copy.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class SyllabusCopyRepository {
  final firestore.FirebaseFirestore _firebaseFirestore;
  final storage.FirebaseStorage _firebaseStorage;
  static late final firestore.CollectionReference coursesCollection;

  SyllabusCopyRepository({
    firestore.FirebaseFirestore? firebaseFirestore,
    storage.FirebaseStorage? firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance {
    coursesCollection =  _firebaseFirestore.collection(FirebaseCollectionConfig.coursesCollectionLabel);
  }

  Future<ApiResponse> uploadSyllabusCopy({
    required File document, required String course,
    required int semester, required int version,
  }) async {

    try {
      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child('syllabus_copy')
          .child("$version.pdf");

      await ref.putFile(document);
      String url = await ref.getDownloadURL();
      return ApiResponse<String>(isError: false, data: url);
    } on storage.FirebaseException catch (_) {
      return ApiResponse(isError: false, errorMessage: "Couldn't upload syllabus copy to storage");
    }
  }


  Future<ApiResponse> uploadAndAddSyllabusCopy({
    required String course, required int semester,
    required UserModel user,
    required int version, required File document,
  }) async {
    try {
      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.CollectionReference syllabusCopyCollection = semesterSnapshot.reference.collection(FirebaseCollectionConfig.syllabusCopyCollectionLabel);

      firestore.QuerySnapshot syllabusCopySnapshot = await syllabusCopyCollection.get();

      if (syllabusCopySnapshot.docs.length >= AppConstants.maxSyllabusCopy) {
        return ApiResponse(isError: true, errorMessage: "The course $course $semester has the maximum syllabus copies. Please refresh to view them");
      }

      ApiResponse uploadResponse = await uploadSyllabusCopy(document: document, course: course, semester: semester, version: version);

      if (uploadResponse.isError) {
        return uploadResponse;
      }

      String documentUrl = uploadResponse.data;
      await syllabusCopyCollection.doc(version.toString()).set(
          {
            "uploaded_by": user.displayName,
            "document_url": documentUrl,
            "user_uid": user.uid,
            "user_profile_photo_url": user.photoUrl,
            "user_email": user.email,
            "uploaded_on": DateTime.now(),
          }
      );

      return ApiResponse(isError: false,);

    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "There was an error while setting question paper: $err");
    }

  }


  Future<ApiResponse> getSyllabusCopies({
    required String course, required int semester,
  }) async {
    try {

      firestore.DocumentSnapshot coursesSnapshot = await coursesCollection.doc(course).get();
      firestore.DocumentSnapshot semesterSnapshot = await coursesSnapshot.reference.collection(FirebaseCollectionConfig.semestersCollectionLabel).doc(semester.toString()).get();
      firestore.QuerySnapshot syllabusCopySnapshot = await semesterSnapshot.reference.collection(FirebaseCollectionConfig.syllabusCopyCollectionLabel).get();

      List<SyllabusCopyModel> syllabusCopies = [];
      syllabusCopySnapshot.docs.forEach((syllabusCopy) {
        print("SEE: ${syllabusCopy.data()}");
        syllabusCopies.add(SyllabusCopyModel.fromFirestoreMap(
          map: syllabusCopy.data() as Map<String, dynamic>,
          version: int.parse(syllabusCopy.id),
        ));
      });

      return ApiResponse<List<SyllabusCopyModel>>(isError: false, data: syllabusCopies);
    } catch (e) {
      print("ERR: $e");
      return ApiResponse(isError: true, errorMessage: "Error while fetching journals");
    }
  }
}