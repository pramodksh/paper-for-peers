part of 'question_paper_bloc.dart';

abstract class QuestionPaperEvent extends Equatable {
  const QuestionPaperEvent();
}

class QuestionPaperFetch extends QuestionPaperEvent {

  final String course;
  final int semester;
  final String subject;

  @override
  List<Object?> get props => [course, semester, subject,];

  const QuestionPaperFetch({
    required this.course,
    required this.semester,
    required this.subject,
  });

  @override
  String toString() {
    return 'QuestionPaperFetch{course: $course, semester: $semester, subject: $subject}';
  }
}

class QuestionPaperAdd extends QuestionPaperEvent {

  final List<QuestionPaperYearModel> questionPaperYears;
  final String uploadedBy;
  final int year;
  final String course;
  final String subject;
  final int semester;
  final UserModel user;

  @override
  List<Object?> get props => [uploadedBy, year, course, subject, semester, user, questionPaperYears];


  const QuestionPaperAdd({
    required this.uploadedBy,
    required this.year,
    required this.course,
    required this.subject,
    required this.semester,
    required this.user,
    required this.questionPaperYears,
  });

  @override
  String toString() {
    return 'QuestionPaperAdd{uploadedBy: $uploadedBy, year: $year, course: $course, subject: $subject, semester: $semester,}';
  }
}

class QuestionPaperAddReport extends QuestionPaperEvent {

  final List<QuestionPaperYearModel> questionPaperYears;
  final List<String> reportValues;
  final int year;
  final String course;
  final String subject;
  final int semester;
  final int nVersion;
  final String userId;

  @override
  List<Object?> get props => [questionPaperYears, reportValues, year, course, subject, semester, nVersion, userId];

  const QuestionPaperAddReport({
    required this.questionPaperYears,
    required this.reportValues,
    required this.year,
    required this.course,
    required this.subject,
    required this.semester,
    required this.nVersion,
    required this.userId,
  });

  @override
  String toString() {
    return 'QuestionPaperAddReport{reportValues: $reportValues, year: $year, course: $course, subject: $subject, semester: $semester, nVersion: $nVersion}';
  }
}

class QuestionPaperReset extends QuestionPaperEvent {
  @override
  List<Object?> get props => [];
}