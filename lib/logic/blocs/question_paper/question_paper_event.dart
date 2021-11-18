part of 'question_paper_bloc.dart';

abstract class QuestionPaperEvent extends Equatable {
  const QuestionPaperEvent();
}

class QuestionPaperFetch extends QuestionPaperEvent {

  final String course;
  final int semester;
  final String subject;

  @override
  List<Object?> get props => [course, semester, subject];

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

  final String uploadedBy;
  final int year;

  @override
  List<Object?> get props => [uploadedBy, year];

  const QuestionPaperAdd({
    required this.uploadedBy,
    required this.year,
  });

  @override
  String toString() {
    return 'QuestionPaperAdd{questionPaper: $uploadedBy, year: $year}';
  }
}