part of 'text_book_bloc.dart';

abstract class TextBookState extends Equatable {
  final int maxTextBooks;
  const TextBookState({required this.maxTextBooks});
}

class TextBookInitial extends TextBookState {
  TextBookInitial({required int maxTextBooks}) : super(maxTextBooks: maxTextBooks);

  @override
  List<Object> get props => [];
}

class TextBookFetchLoading extends TextBookState {
  TextBookFetchLoading({required int maxTextBooks}) : super(maxTextBooks: maxTextBooks);

  @override
  List<Object?> get props => [];
}

class TextBookFetchSuccess extends TextBookState {

  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [textBookSubjects];

  const TextBookFetchSuccess({
    required this.textBookSubjects,
    required int maxTextBooks
  }) : super(maxTextBooks: maxTextBooks);
}

class TextBookFetchError extends TextBookState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const TextBookFetchError({
    required this.errorMessage,
    required int maxTextBooks
  }) : super(maxTextBooks: maxTextBooks);
}

class TextBookAddLoading extends TextBookState {

  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [textBookSubjects];

  const TextBookAddLoading({
    required this.textBookSubjects,
    required int maxTextBooks
  }) : super(maxTextBooks: maxTextBooks);
}

class TextBookAddSuccess extends TextBookState {
  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [textBookSubjects];

  const TextBookAddSuccess({
    required this.textBookSubjects,
    required int maxTextBooks
  }) : super(maxTextBooks: maxTextBooks);
}

class TextBookAddError extends TextBookState {

  final String errorMessage;
  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [errorMessage, textBookSubjects];

  const TextBookAddError({
    required this.errorMessage,
    required this.textBookSubjects,
    required int maxTextBooks
  }) : super(maxTextBooks: maxTextBooks);
}

class TextBookReportSuccess extends TextBookState {
  TextBookReportSuccess({required int maxTextBooks}) : super(maxTextBooks: maxTextBooks);

  @override
  List<Object?> get props => [];
}

class TextBookReportError extends TextBookState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const TextBookReportError({
    required this.errorMessage,
    required int maxTextBooks
  }) : super(maxTextBooks: maxTextBooks);
}