import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:papers_for_peers/data/models/api_response.dart';

class FirebaseStorageRepository {
  final storage.FirebaseStorage _firebaseStorage;

  FirebaseStorageRepository({storage.FirebaseStorage? firebaseStorage})
    : _firebaseStorage = firebaseStorage ?? storage.FirebaseStorage.instance;

  Future<ApiResponse> uploadProfilePhotoAndGetUrl({required File file, required String userId}) async {

    try {
      // Reference ref = storage.ref('profile_photos/file-to-upload.png');
      storage.Reference ref = _firebaseStorage.ref('profile_photos').child(userId).child("photo.png");
      await ref.putFile(file);
      print("UPLOADED");
      String url = await ref.getDownloadURL();
      return ApiResponse<String>(isError: false, data: url);
    } on storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("FILE UPLOAD ERROR: $e");
      return ApiResponse(isError: false, errorMessage: "Couldn't upload data");
    }
  }

  Future<ApiResponse> uploadQuestionPaper({
    required File document, required int year,
    required String course, required int semester,
    required String subject, required int version,
  }) async {
    try {

      print("UPLOADING IT");
      // /courses_new/bca/semesters/1/subjects/java/question_paper/2019/versions/1

      storage.Reference ref = _firebaseStorage.ref('courses').child(course)
          .child(semester.toString()).child(subject).child('question_paper')
          .child(year.toString()).child("$version.pdf");

      await ref.putFile(document);
      print("UPLOADED QUESTION PAPER");
      String url = await ref.getDownloadURL();
      return ApiResponse<String>(isError: false, data: url);
    } on storage.FirebaseException catch (e) {
      print("Question paper FILE UPLOAD ERROR: $e");
      return ApiResponse(isError: false, errorMessage: "Couldn't upload question paper to storage");
    }
  }
}