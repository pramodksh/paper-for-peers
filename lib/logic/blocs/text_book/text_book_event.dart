part of 'text_book_bloc.dart';

abstract class TextBookEvent extends Equatable {
  const TextBookEvent();
}

class TextBookFetch extends TextBookEvent {
  final String course;
  final int semester;

  @override
  List<Object?> get props => [course, semester,];

  const TextBookFetch({
    required this.course,
    required this.semester,
  });

  @override
  String toString() {
    return 'TextBookFetch{course: $course, semester: $semester,}';
  }
}

class TextBookAdd extends TextBookEvent {

  final List<TextBookSubjectModel> textBookSubjects;
  final String uploadedBy;
  final String course;
  final Subject subject;
  final int semester;
  final UserModel user;

  @override
  List<Object?> get props => [uploadedBy, course, subject, semester, user, textBookSubjects];

  const TextBookAdd({
    required this.textBookSubjects,
    required this.uploadedBy,
    required this.course,
    required this.subject,
    required this.semester,
    required this.user,
  });
}

class TextBookReportAdd extends TextBookEvent {
  final List<String> reportValues;
  final List<TextBookSubjectModel> textBookSubjects;
  final String uploadedBy;
  final String course;
  final Subject subject;
  final int semester;
  final String textBookId;
  final UserModel user;

  @override
  List<Object?> get props => [uploadedBy, course, subject, semester, textBookId, user, textBookSubjects];

  const TextBookReportAdd({
    required this.reportValues,
    required this.textBookSubjects,
    required this.uploadedBy,
    required this.course,
    required this.subject,
    required this.semester,
    required this.textBookId,
    required this.user,
  });

  @override
  String toString() {
    return 'TextBookReportAdd{reportValues: $reportValues, textBookSubjects: $textBookSubjects, uploadedBy: $uploadedBy, course: $course, subject: $subject, semester: $semester, nVersion: $textBookId, user: $user}';
  }
}