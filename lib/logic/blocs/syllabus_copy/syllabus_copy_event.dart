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

  final List<SyllabusCopyModel> syllabusCopies;
  final UserModel user;

  @override
  List<Object?> get props => [user, syllabusCopies];

  const SyllabusCopyAdd({
    required this.syllabusCopies,
    required this.user,
  });
}

class SyllabusCopyReportAdd extends SyllabusCopyEvent {
  final List<String> reportValues;
  final List<SyllabusCopyModel> syllabusCopies;
  final UserModel user;
  final String syllabusCopyId;

  @override
  List<Object?> get props => [syllabusCopyId, user, syllabusCopies, reportValues];

  const SyllabusCopyReportAdd({
    required this.reportValues,
    required this.syllabusCopies,
    required this.user,
    required this.syllabusCopyId,
  });

  @override
  String toString() {
    return 'SyllabusCopyReportAdd{reportValues: $reportValues, syllabusCopies: $syllabusCopies, user: $user, version: $syllabusCopyId}';
  }
}