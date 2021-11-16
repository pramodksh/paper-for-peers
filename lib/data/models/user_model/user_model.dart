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

  UserModel({
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.uid,
    this.semester,
    this.course
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    int? semester,
    String? course,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      semester: semester ?? this.semester,
      course: course ?? this.course,
    );
  }
}