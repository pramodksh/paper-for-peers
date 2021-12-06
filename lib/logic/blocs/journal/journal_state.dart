part of 'journal_bloc.dart';

abstract class JournalState extends Equatable {
  final int maxJournals;
  const JournalState({required this.maxJournals});
}

class JournalInitial extends JournalState {
  JournalInitial({required int maxJournals}) : super(maxJournals: maxJournals);

  @override
  List<Object> get props => [];
}

class JournalFetchLoading extends JournalState {
  JournalFetchLoading({required int maxJournals}) : super(maxJournals: maxJournals);

  @override
  List<Object?> get props => [];
}

class JournalFetchSuccess extends JournalState {
  
  final List<JournalSubjectModel> journalSubjects;
  
  JournalFetchSuccess({
    required this.journalSubjects,
    required int maxJournals
  }) : super(maxJournals: maxJournals);

  @override
  List<Object?> get props => [journalSubjects];
  
}

class JournalFetchError extends JournalState {
  final String errorMessage;
  
  JournalFetchError({
    required this.errorMessage,
    required int maxJournals
  }) : super(maxJournals: maxJournals);
  
  @override
  List<Object?> get props => [errorMessage];
  
}

class JournalAddLoading extends JournalState {

  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [journalSubjects];

  const JournalAddLoading({
    required this.journalSubjects,
    required int maxJournals
  }) : super(maxJournals: maxJournals);
}

class JournalAddSuccess extends JournalState {
  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [journalSubjects];

  const JournalAddSuccess({
    required this.journalSubjects,
    required int maxJournals
  }) : super(maxJournals: maxJournals);
}

class JournalAddError extends JournalState {

  final String errorMessage;
  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [errorMessage, journalSubjects];

  const JournalAddError({
    required this.errorMessage,
    required this.journalSubjects,
    required int maxJournals
  }) : super(maxJournals: maxJournals);
}

class JournalReportSuccess extends JournalState {
  JournalReportSuccess({required int maxJournals}) : super(maxJournals: maxJournals);


  @override
  List<Object?> get props => [];
}

class JournalReportError extends JournalState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const JournalReportError({
    required this.errorMessage,
    required int maxJournals
  }) : super(maxJournals: maxJournals);
}