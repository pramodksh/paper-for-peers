


class Course {
  String courseName;
  List<Semester> semesters;

  Course({required this.courseName, required this.semesters});
}

class Semester {
  int semester;
  List<String> subjects;

  Semester({required this.subjects, required this.semester});
}

List<Course> getCourses() {
  Course bca = Course(
    courseName: "BCA",
    semesters: [
      Semester(semester: 1, subjects: ["JAVA", "OOPS", "English", "Hindi"]),
      Semester(semester: 2, subjects: ["HTML", "App Development", "French", "Italian"]),
      Semester(semester: 3, subjects: ["ABC", "XYZ", "JKL", "LOP"]),
      Semester(semester: 4, subjects: ["ABC", "XYZ", "JKL", "LOP"]),
    ]
  );

  Course bba = Course(
      courseName: "BBA",
      semesters: [
        Semester(semester: 1, subjects: ["ABC", "QWE", "RTY", "ZXC"]),
        Semester(semester: 2, subjects: ["FGH", "POI", "MKP", "BHU"]),
        Semester(semester: 3, subjects: ["ZXC", "XYZ", "JKL", "LOP"]),
      ]
  );

  Course bcom = Course(
      courseName: "BCOM",
      semesters: [
        Semester(semester: 1, subjects: ["QZZZ", "XCAV", "ASWC", "QAWZ"]),
        Semester(semester: 2, subjects: ["ZSXA", "CADFE", "ZASW", "AQSW"]),
        // Semester(semester: 3, subjects: ["ASWQ", "GRFT", "BGRF", "CDFE"]),
      ]
  );

  return [bca, bba, bcom];
}