part of 'question_paper_bloc.dart';

abstract class QuestionPaperState extends Equatable {
  const QuestionPaperState();
}

class QuestionPaperInitial extends QuestionPaperState {
  @override
  List<Object> get props => [];
}

class QuestionPaperFetchLoading extends QuestionPaperState {
  @override
  List<Object?> get props => [];
}

class QuestionPaperFetchSuccess extends QuestionPaperState {

  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperFetchSuccess({
    required this.questionPaperYears,
  });
}

class QuestionPaperFetchError extends QuestionPaperState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const QuestionPaperFetchError({
    required this.errorMessage,
  });
}

class QuestionPaperAddLoading extends QuestionPaperState {

  final List<QuestionPaperYearModel> questionPaperYears;

  @override
  List<Object?> get props => [questionPaperYears];

  const QuestionPaperAddLoading({
    required this.questionPaperYears,
  });
}

class QuestionPaperAddSuccess extends QuestionPaperState {
  @override
  List<Object?> get props => [];
}

class QuestionPaperAddError extends QuestionPaperState {

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const QuestionPaperAddError({
    required this.errorMessage,
  });
}