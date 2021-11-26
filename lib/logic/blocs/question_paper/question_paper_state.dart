part of 'question_paper_bloc.dart';

abstract class QuestionPaperState extends Equatable {
  final String? selectedSubject;

  const QuestionPaperState({required this.selectedSubject});
}

class QuestionPaperInitial extends QuestionPaperState {
  QuestionPaperInitial() : super(selectedSubject: null);

  @override
  List<Object> get props => [];
}

class QuestionPaperFetchLoading extends QuestionPaperState {
  QuestionPaperFetchLoading({required String selectedSubject}) : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [];
}

class QuestionPaperFetchSuccess extends QuestionPaperState {

  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperFetchSuccess({
    required this.questionPaperYears,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class QuestionPaperFetchError extends QuestionPaperState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const QuestionPaperFetchError({
    required this.errorMessage,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class QuestionPaperAddLoading extends QuestionPaperState {

  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperAddLoading({
    required this.questionPaperYears,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class QuestionPaperAddSuccess extends QuestionPaperState {
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperAddSuccess({
    required this.questionPaperYears,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class QuestionPaperAddError extends QuestionPaperState {

  final String errorMessage;
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [errorMessage, questionPaperYears];

  const QuestionPaperAddError({
    required this.errorMessage,
    required this.questionPaperYears,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class QuestionPaperReportSuccess extends QuestionPaperState {
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperReportSuccess({
    required this.questionPaperYears,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class QuestionPaperReportError extends QuestionPaperState {
  final String errorMessage;
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears, errorMessage];

  const QuestionPaperReportError({
    required this.errorMessage,
    required this.questionPaperYears,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}
