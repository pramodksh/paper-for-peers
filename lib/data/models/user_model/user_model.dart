import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';

class UserModel {

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final Semester? semester;
  final Course? course;
  final int? totalRating;
  final double? avgRating;
  final List<String> fcmTokenList;

  static String courseLabel = "course";
  static String semesterLabel = "semester";
  static String fcmTokenListLabel = "fcm_token_list";

  static Future<UserModel> getUserModelByMap({
    required Map userMap, required String userId,
    required Function(String) getCourse,
    required int totalRatings, required double avgRating,
    required List<String> fcmTokenList,
  }) async {
    Course? course;
    Semester? semester;

    if (userMap[courseLabel] != null) {
      course = await getCourse(userMap[courseLabel].toString().toLowerCase());
      if (userMap[semesterLabel] != null) {
        semester = course!.semesters!.firstWhere((element) => element.nSemester == userMap[semesterLabel]);
      }
    }

    return UserModel(
      fcmTokenList: fcmTokenList,
      uid: userId,
      displayName: userMap['displayName'],
      email: userMap['email'],
      photoUrl: userMap['photoUrl'],
      semester: semester,
      course: course,
      avgRating: avgRating,
      totalRating: totalRatings,
    );
  }

  UserModel({
    required this.fcmTokenList,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.uid,
    this.semester,
    this.course,
    this.avgRating,
    this.totalRating,
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    Semester? semester,
    Course? course,
    int? totalRating,
    double? avgRating,
    List<String>? fcmTokenList,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      semester: semester ?? this.semester,
      course: course ?? this.course,
      totalRating: totalRating ?? this.totalRating,
      avgRating: avgRating ?? this.avgRating,
      fcmTokenList: fcmTokenList ?? this.fcmTokenList,
    );
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, displayName: $displayName, email: $email, photoUrl: $photoUrl, semester: $semester, course: $course, totalRating: $totalRating, avgRating: $avgRating}';
  }
}