import 'package:papers_for_peers/data/models/semester.dart';

class Course {
  String courseName;
  List<Semester> semesters;

  Course({required this.courseName, required this.semesters});
}