part of 'syllabus_copy_bloc.dart';

abstract class SyllabusCopyEvent extends Equatable {
  const SyllabusCopyEvent();
}

class SyllabusCopyFetch extends SyllabusCopyEvent {
  final String course;
  final int semester;

  @override
  List<Object?> get props => [course, semester];

  const SyllabusCopyFetch({
    required this.course,
    required this.semester,
  });

  @override
  String toString() {
    return 'SyllabusCopyFetch{course: $course, semester: $semester}';
  }
}

class SyllabusCopyAdd extends SyllabusCopyEvent {
  final String course;
  final int semester;
  final int version;

  @override
  List<Object?> get props => [course, semester, version];

  const SyllabusCopyAdd({
    required this.course,
    required this.semester,
    required this.version,
  });

  @override
  String toString() {
    return 'SyllabusCopyAdd{course: $course, semester: $semester, version: $version}';
  }
}