class Semester {
  int? nSemester;
  List<String> subjects;

  Semester({required this.subjects, required this.nSemester});

  @override
  String toString() {
    return 'Semester{semester: $nSemester, subjects: $subjects}';
  }
}