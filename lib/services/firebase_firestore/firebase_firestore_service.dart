 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

class FirebaseFireStoreService {
  static final String usersCollectionLabel = "users";
  // static String documentsCollectionLabel = "";

  static final String coursesCollectionLabel = "courses";
  static final String semestersCollectionLabel = "semesters";
  static final String questionPaperCollectionLabel = "question_paper";
  static final String yearsCollectionLabel = "years";
  static final String versionsCollectionLabel = "versions";

  CollectionReference usersCollection = FirebaseFirestore.instance.collection(usersCollectionLabel);

  Future<bool> isUserExists({required String userId}) async {
    DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return userDocumentSnapshot.exists;
  }

  Future<UserModel> getUserByUserId({required String userId}) async {
    DocumentSnapshot userDocumentSnapshot = await usersCollection.doc(userId).get();
    return UserModel.getUserModelByMap(userMap: userDocumentSnapshot.data() as Map<dynamic, dynamic>, userId: userId);
  }

  Future<ApiResponse> addUser({required UserModel user}) async {
    try {
      await usersCollection.doc(user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        UserModel.courseLabel: user.course,
        UserModel.semesterLabel: user.semester,
      });
      return ApiResponse(isError: false);
    } catch (err) {
      return ApiResponse(isError: true, errorMessage: "Failed to add user: ERR: $err");
    }
  }

}