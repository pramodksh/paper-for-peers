part of 'question_paper_bloc.dart';

abstract class QuestionPaperState extends Equatable {
  final int maxQuestionPapers;
  final Subject? selectedSubject;

  const QuestionPaperState({required this.selectedSubject, required this.maxQuestionPapers});
}

class QuestionPaperInitial extends QuestionPaperState {
  QuestionPaperInitial({required int maxQuestionPapers}) : super(selectedSubject: null, maxQuestionPapers: maxQuestionPapers);

  @override
  List<Object> get props => [];
}

class QuestionPaperFetchLoading extends QuestionPaperState {
  QuestionPaperFetchLoading({
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);

  @override
  List<Object?> get props => [];
}

class QuestionPaperFetchSuccess extends QuestionPaperState {

  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperFetchSuccess({
    required this.questionPaperYears,
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);
}

class QuestionPaperFetchError extends QuestionPaperState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const QuestionPaperFetchError({
    required this.errorMessage,
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);
}

class QuestionPaperAddLoading extends QuestionPaperState {

  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperAddLoading({
    required this.questionPaperYears,
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);
}

class QuestionPaperAddSuccess extends QuestionPaperState {
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperAddSuccess({
    required this.questionPaperYears,
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);
}

class QuestionPaperAddError extends QuestionPaperState {

  final String errorMessage;
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [errorMessage, questionPaperYears];

  const QuestionPaperAddError({
    required this.errorMessage,
    required this.questionPaperYears,
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);
}

class QuestionPaperReportSuccess extends QuestionPaperState {
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperReportSuccess({
    required this.questionPaperYears,
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);
}

class QuestionPaperReportError extends QuestionPaperState {
  final String errorMessage;
  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears, errorMessage];

  const QuestionPaperReportError({
    required this.errorMessage,
    required this.questionPaperYears,
    required Subject selectedSubject,
    required int maxQuestionPapers
  }) : super(selectedSubject: selectedSubject, maxQuestionPapers: maxQuestionPapers);
}
