part of 'journal_bloc.dart';

abstract class JournalState extends Equatable {
  const JournalState();
}

class JournalInitial extends JournalState {
  JournalInitial() : super();

  @override
  List<Object> get props => [];
}

class JournalFetchLoading extends JournalState {
  JournalFetchLoading() : super();

  @override
  List<Object?> get props => [];
}

class JournalFetchSuccess extends JournalState {
  
  final List<JournalSubjectModel> journalSubjects;
  
  JournalFetchSuccess({
    required this.journalSubjects,
  }) : super();

  @override
  List<Object?> get props => [journalSubjects];
  
}

class JournalFetchError extends JournalState {
  final String errorMessage;
  
  JournalFetchError({
    required this.errorMessage,
  }) : super();
  
  @override
  List<Object?> get props => [errorMessage];
  
}

class JournalAddLoading extends JournalState {

  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [journalSubjects];

  const JournalAddLoading({
    required this.journalSubjects,
  }) : super();
}

class JournalAddSuccess extends JournalState {
  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [journalSubjects];

  const JournalAddSuccess({
    required this.journalSubjects,
  }) : super();
}

class JournalAddError extends JournalState {

  final String errorMessage;
  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [errorMessage, journalSubjects];

  const JournalAddError({
    required this.errorMessage,
    required this.journalSubjects,
  }) : super();
}

class JournalReportSuccess extends JournalState {

  @override
  List<Object?> get props => [];
}

class JournalReportError extends JournalState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const JournalReportError({
    required this.errorMessage,
  });
}