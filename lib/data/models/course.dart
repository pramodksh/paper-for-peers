import 'package:papers_for_peers/data/models/semester.dart';

class Course {
  String? courseName;
  List<Semester>? semesters;

  Course({required this.courseName, required this.semesters});

  @override
  String toString() {
    return 'Course{_courseName: $courseName, semesters: $semesters}';
  }
}