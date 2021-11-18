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
}