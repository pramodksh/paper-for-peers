import 'package:flutter/material.dart';

class UserModel {
  String uid;
  String displayName;
  String email;
  String photoUrl;
  int semester;
  String course;

  static String courseLabel = "course";
  static String semesterLabel = "semester";

  static UserModel getUserModelByMap({@required Map userMap, @required String userId}) {
    return UserModel(
      uid: userId,
      displayName: userMap['displayName'],
      email: userMap['email'],
      photoUrl: userMap['photoUrl'],
      semester: userMap[semesterLabel],
      course: userMap[courseLabel],
    );
  }

  bool isAuthDataAvailable() {
    return this.uid != null && this.displayName != null && this.email != null && this.photoUrl != null;
  }

  UserModel({this.email, this.displayName, this.photoUrl, this.uid, this.semester, this.course});
}