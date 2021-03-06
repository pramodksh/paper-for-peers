part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  final Subject? selectedSubject;
  const NotesState({required this.selectedSubject});
}

class NotesInitial extends NotesState {
  NotesInitial() : super(selectedSubject: null);

  @override
  List<Object> get props => [];
}

class NotesFetchLoading extends NotesState {
  NotesFetchLoading({required Subject selectedSubject}) : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [];
}

class NotesFetchSuccess extends NotesState {

  final List<NotesModel> notes;

  @override
  List<Object?> get props => [notes];

  const NotesFetchSuccess({
    required this.notes,
    required Subject selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class NotesFetchError extends NotesState {
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  const NotesFetchError({
    required this.errorMessage,
    required Subject selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}


class NotesAddEditing extends NotesState {
  final String? title;
  final String? description;
  final File? file;

  @override
  List<Object?> get props => [title, description, file];

  const NotesAddEditing({
    required this.title,
    required this.description,
    required this.file,
    required Subject selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}


class NotesAddLoading extends NotesState {

  @override
  List<Object?> get props => [];

  const NotesAddLoading({
    required Subject selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class NotesAddSuccess extends NotesState {

  final String? title;
  final String? description;
  final File? file;

  @override
  List<Object?> get props => [file, title, description];

  const NotesAddSuccess({
    required this.title,
    required this.description,
    required this.file,
    required Subject selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class NotesAddError extends NotesState {

  final String errorMessage;
  final String? title;
  final String? description;
  final File? file;

  @override
  List<Object?> get props => [errorMessage, file, title, description];

  const NotesAddError({
    required this.title,
    required this.description,
    required this.file,
    required this.errorMessage,
    required Subject selectedSubject,
  }) : super(selectedSubject: selectedSubject);
}

class NotesReportAddSuccess extends NotesState {
  NotesReportAddSuccess({required Subject selectedSubject}) : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [];
}

class NotesReportAddError extends NotesState {
  final String errorMessage;

  NotesReportAddError({required Subject selectedSubject, required this.errorMessage})
      : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [errorMessage];
}

class NotesDeleteLoading extends NotesState {
  final List<NotesModel> notes;

  @override
  List<Object?> get props => [notes];

  NotesDeleteLoading({required this.notes, required Subject selectedSubject}) : super(selectedSubject: selectedSubject);

}

class NotesDeleteSuccess extends NotesState {
  NotesDeleteSuccess({required Subject selectedSubject}) : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [];
}

class NotesDeleteError extends NotesState {
  final String errorMessage;
  NotesDeleteError({required Subject selectedSubject, required this.errorMessage}) : super(selectedSubject: selectedSubject);

  @override
  List<Object?> get props => [errorMessage];
}