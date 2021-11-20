part of 'journal_bloc.dart';

abstract class JournalState extends Equatable {
  final String? selectedSubject;
  const JournalState({required this.selectedSubject});
}

class JournalInitial extends JournalState {
  JournalInitial() : super(selectedSubject: null);

  @override
  List<Object> get props => [];
}

class JournalFetchLoading extends JournalState {
  JournalFetchLoading({required String selectedSubject}) : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [];
}

class JournalFetchSuccess extends JournalState {
  
  final List<JournalSubjectModel> journalSubjects;
  
  JournalFetchSuccess({
    required this.journalSubjects,
    required String selectedSubject, 
  }) : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [journalSubjects];
  
}

class JournalFetchError extends JournalState {
  final String errorMessage;
  
  JournalFetchError({
    required this.errorMessage,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
  
  @override
  List<Object?> get props => [errorMessage];
  
}

class JournalAddLoading extends JournalState {

  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [journalSubjects];

  const JournalAddLoading({
    required this.journalSubjects,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class JournalAddSuccess extends JournalState {
  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [journalSubjects];

  const JournalAddSuccess({
    required this.journalSubjects,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class JournalAddError extends JournalState {

  final String errorMessage;
  final List<JournalSubjectModel> journalSubjects;

  @override
  List<Object?> get props => [errorMessage, journalSubjects];

  const JournalAddError({
    required this.errorMessage,
    required this.journalSubjects,
    required String selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

