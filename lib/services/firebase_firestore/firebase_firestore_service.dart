 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class FirebaseFireStoreService {
  static String usersCollectionLabel = "users";
  // static String documentsCollectionLabel = "";

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference usersCollection = FirebaseFirestore.instance.collection(usersCollectionLabel);

  Future<bool> isUserExists({required String userId}) async {
    DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return userDocumentSnapshot.exists;
  }

  Future<UserModel> getUserByUserId({required String userId}) async {
    DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return UserModel.getUserModelByMap(userMap: userDocumentSnapshot.data() as Map<dynamic, dynamic>, userId: userId);
  }

  Future<ApiResponse> addUser({required UserModel user}) {
      return usersCollection.doc(user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        UserModel.courseLabel: user.course,
        UserModel.semesterLabel: user.semester,
      }).then((value) => ApiResponse(isError: false))
          .catchError((error) => ApiResponse(isError: true, errorMessage: "Failed to add user: ERR: $error"));
  }

}