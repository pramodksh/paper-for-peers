part of 'syllabus_copy_bloc.dart';

abstract class SyllabusCopyState extends Equatable {
  final int maxSyllabusCopy;
  const SyllabusCopyState({required this.maxSyllabusCopy});
}

class SyllabusCopyInitial extends SyllabusCopyState {
  SyllabusCopyInitial({required int maxSyllabusCopy}) : super(maxSyllabusCopy: maxSyllabusCopy);

  @override
  List<Object> get props => [];
}

class SyllabusCopyFetchLoading extends SyllabusCopyState {
  SyllabusCopyFetchLoading({required int maxSyllabusCopy}) : super(maxSyllabusCopy: maxSyllabusCopy);

  @override
  List<Object?> get props => [];
}

class SyllabusCopyFetchSuccess extends SyllabusCopyState {

  final List<SyllabusCopyModel> syllabusCopies;

  SyllabusCopyFetchSuccess({
    required this.syllabusCopies,
    required int maxSyllabusCopy
  }) : super(maxSyllabusCopy: maxSyllabusCopy);

  @override
  List<Object?> get props => [syllabusCopies];

}

class SyllabusCopyFetchError extends SyllabusCopyState {
  final String errorMessage;

  SyllabusCopyFetchError({
    required this.errorMessage,
    required int maxSyllabusCopy
  }) : super(maxSyllabusCopy: maxSyllabusCopy);

  @override
  List<Object?> get props => [errorMessage];

}

class SyllabusCopyAddLoading extends SyllabusCopyState {

  final List<SyllabusCopyModel> syllabusCopies;

  @override
  List<Object?> get props => [syllabusCopies];

  const SyllabusCopyAddLoading({
    required this.syllabusCopies,
    required int maxSyllabusCopy
  }) : super(maxSyllabusCopy: maxSyllabusCopy);
}

class SyllabusCopyAddSuccess extends SyllabusCopyState {
  final List<SyllabusCopyModel> syllabusCopies;

  @override
  List<Object?> get props => [syllabusCopies];

  const SyllabusCopyAddSuccess({
    required this.syllabusCopies,
    required int maxSyllabusCopy
  }) : super(maxSyllabusCopy: maxSyllabusCopy);
}

class SyllabusCopyAddError extends SyllabusCopyState {

  final String errorMessage;
  final List<SyllabusCopyModel> syllabusCopies;

  @override
  List<Object?> get props => [errorMessage, syllabusCopies];

  const SyllabusCopyAddError({
    required this.errorMessage,
    required this.syllabusCopies,
    required int maxSyllabusCopy
  }) : super(maxSyllabusCopy: maxSyllabusCopy);
}

class SyllabusCopyReportSuccess extends SyllabusCopyState {
  SyllabusCopyReportSuccess({required int maxSyllabusCopy}) : super(maxSyllabusCopy: maxSyllabusCopy);

  @override
  List<Object?> get props => [];
}

class SyllabusCopyReportError extends SyllabusCopyState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const SyllabusCopyReportError({
    required this.errorMessage,
    required int maxSyllabusCopy
  }) : super(maxSyllabusCopy: maxSyllabusCopy);
}