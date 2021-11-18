
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';

class UserModel {
  final String uid;
  String? displayName;
  final String? email;
  String? photoUrl;
  Semester? semester;
  Course? course;

  static String courseLabel = "course";
  static String semesterLabel = "semester";

  static Future<UserModel> getUserModelByMap({required Map userMap, required String userId, required Function(String) getCourse}) async {
    Course? course;
    Semester? semester;

    if (userMap[courseLabel] != null) {
      course = await getCourse(userMap[courseLabel].toString().toLowerCase());
      if (userMap[semesterLabel] != null) {
        semester = course!.semesters!.firstWhere((element) => element.semester == userMap[semesterLabel]);
      }
    }

    return UserModel(
      uid: userId,
      displayName: userMap['displayName'],
      email: userMap['email'],
      photoUrl: userMap['photoUrl'],
      semester: semester,
      course: course
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
    Semester? semester,
    Course? course,
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

  @override
  String toString() {
    return 'UserModel{uid: $uid, displayName: $displayName, email: $email, photoUrl: $photoUrl, semester: $semester, course: $course}';
  }
}