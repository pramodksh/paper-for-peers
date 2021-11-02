

class UserModel {
  final String uid;
  String? displayName;
  final String? email;
  String? photoUrl;
  int? semester;
  String? course;

  static String courseLabel = "course";
  static String semesterLabel = "semester";

  static UserModel getUserModelByMap({required Map userMap, required String userId}) {
    return UserModel(
      uid: userId,
      displayName: userMap['displayName'],
      email: userMap['email'],
      photoUrl: userMap['photoUrl'],
      semester: userMap[semesterLabel],
      course: userMap[courseLabel],
    );
  }

  // bool isEmailPasswordAuthDataAvailable() {
  //   return this.email != null;
  // }
  //
  // bool isGoogleAuthDataAvailable() {
  //   return this.uid != null && this.displayName != null && this.email != null && this.photoUrl != null;
  // }

  UserModel({
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.uid,
    this.semester,
    this.course
  });
}