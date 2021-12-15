import 'package:papers_for_peers/data/models/user_model/subject.dart';

class Semester {
  int? nSemester;
  List<Subject> subjects;

  Semester({required this.subjects, required this.nSemester});

  @override
  String toString() {
    return 'Semester{semester: $nSemester, subjects: $subjects}';
  }
}