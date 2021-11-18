import 'package:papers_for_peers/data/models/semester.dart';

class Course {
  String? _courseName;
  List<Semester>? semesters;

  String? get courseName => this._courseName?.toUpperCase();

  Course({required String? courseName, required this.semesters})
    : _courseName = courseName;

  @override
  String toString() {
    return 'Course{_courseName: $_courseName, semesters: $semesters}';
  }
}