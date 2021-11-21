part of 'syllabus_copy_bloc.dart';

abstract class SyllabusCopyState extends Equatable {
  const SyllabusCopyState();
}

class SyllabusCopyInitial extends SyllabusCopyState {
  SyllabusCopyInitial() : super();

  @override
  List<Object> get props => [];
}

class SyllabusCopyFetchLoading extends SyllabusCopyState {
  SyllabusCopyFetchLoading() : super();

  @override
  List<Object?> get props => [];
}

class SyllabusCopyFetchSuccess extends SyllabusCopyState {

  final List<SyllabusCopyModel> syllabusCopies;

  SyllabusCopyFetchSuccess({
    required this.syllabusCopies,
  }) : super();

  @override
  List<Object?> get props => [syllabusCopies];

}

class SyllabusCopyFetchError extends SyllabusCopyState {
  final String errorMessage;

  SyllabusCopyFetchError({
    required this.errorMessage,
  }) : super();

  @override
  List<Object?> get props => [errorMessage];

}

class SyllabusCopyAddLoading extends SyllabusCopyState {

  final List<SyllabusCopyModel> syllabusCopies;

  @override
  List<Object?> get props => [syllabusCopies];

  const SyllabusCopyAddLoading({
    required this.syllabusCopies,
  }) : super();
}

class SyllabusCopyAddSuccess extends SyllabusCopyState {
  final List<SyllabusCopyModel> syllabusCopies;

  @override
  List<Object?> get props => [syllabusCopies];

  const SyllabusCopyAddSuccess({
    required this.syllabusCopies,
  }) : super();
}

class SyllabusCopyAddError extends SyllabusCopyState {

  final String errorMessage;
  final List<SyllabusCopyModel> syllabusCopies;

  @override
  List<Object?> get props => [errorMessage, syllabusCopies];

  const SyllabusCopyAddError({
    required this.errorMessage,
    required this.syllabusCopies,
  }) : super();
}

