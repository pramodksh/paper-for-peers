class Semester {
  int? semester;
  List<String> subjects;

  Semester({required this.subjects, required this.semester});

  @override
  String toString() {
    return 'Semester{semester: $semester, subjects: $subjects}';
  }
}