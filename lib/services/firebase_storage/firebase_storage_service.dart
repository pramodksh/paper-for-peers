import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:papers_for_peers/data/models/api_response.dart';

class FirebaseStorageService {

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<ApiResponse> uploadProfilePhoto({required File file, required String userId}) async {

    try {
      // Reference ref = storage.ref('profile_photos/file-to-upload.png');
      Reference ref = storage.ref('profile_photos').child(userId).child("photo.png");
      await ref.putFile(file);
      print("UPLOADED");
      String url = await ref.getDownloadURL();
      return ApiResponse<String>(isError: false, data: url);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("FILE UPLOAD ERROR: $e");
      return ApiResponse(isError: false, errorMessage: "Couldn't upload data");
    }
  }

}