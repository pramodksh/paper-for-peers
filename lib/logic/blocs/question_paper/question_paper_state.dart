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