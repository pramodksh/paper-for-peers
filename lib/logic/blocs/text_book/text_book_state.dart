part of 'text_book_bloc.dart';

abstract class TextBookState extends Equatable {
  const TextBookState();
}

class TextBookInitial extends TextBookState {
  TextBookInitial() : super();

  @override
  List<Object> get props => [];
}

class TextBookFetchLoading extends TextBookState {
  TextBookFetchLoading() : super();

  @override
  List<Object?> get props => [];
}

class TextBookFetchSuccess extends TextBookState {

  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [textBookSubjects];

  const TextBookFetchSuccess({
    required this.textBookSubjects,
  }) : super();
}

class TextBookFetchError extends TextBookState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const TextBookFetchError({
    required this.errorMessage,
  }) : super();
}

class TextBookAddLoading extends TextBookState {

  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [textBookSubjects];

  const TextBookAddLoading({
    required this.textBookSubjects,
  }) : super();
}

class TextBookAddSuccess extends TextBookState {
  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [textBookSubjects];

  const TextBookAddSuccess({
    required this.textBookSubjects,
  }) : super();
}

class TextBookAddError extends TextBookState {

  final String errorMessage;
  final List<TextBookSubjectModel> textBookSubjects;

  @override
  List<Object?> get props => [errorMessage, textBookSubjects];

  const TextBookAddError({
    required this.errorMessage,
    required this.textBookSubjects,
  }) : super();
}
