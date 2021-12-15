part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

class NotesFetch extends NotesEvent {
  final String course;
  final int semester;
  final Subject subject;

  @override
  List<Object?> get props => [course, semester, subject,];

  const NotesFetch({
    required this.course,
    required this.semester,
    required this.subject,
  });
}

class NotesAddEdit extends NotesEvent {

  final Subject subject;
  final String? title;
  final String? description;
  final bool isFileEdit;

  @override
  List<Object?> get props => [title, description, subject];

  const NotesAddEdit({
    required this.title,
    required this.description,
    required this.subject,
    this.isFileEdit = false,
  });

  @override
  String toString() {
    return 'NotesAddEdit{subject: $subject, title: $title, description: $description, isFileEdit: $isFileEdit}';
  }

}

class NotesAdd extends NotesEvent {

  final File? file;
  final String title;
  final String description;
  final UserModel user;
  final Subject subject;

  @override
  List<Object?> get props => [title, description, user, subject,];

  const NotesAdd({
    required this.file,
    required this.title,
    required this.description,
    required this.user,
    required this.subject,
  });

  @override
  String toString() {
    return 'NotesAdd{file: $file, title: $title, description: $description, user: $user, subject: $subject,}';
  }
}

class NotesReportAdd extends NotesEvent {
  final Subject subject;
  final List<String> reportValues;
  final List<NotesModel> notes;
  final String noteId;
  final String course;
  final int semester;
  final UserModel user;

  @override
  List<Object?> get props => [subject, notes, course, semester, noteId, reportValues, user];

  const NotesReportAdd({
    required this.user,
    required this.reportValues,
    required this.noteId,
    required this.semester,
    required this.course,
    required this.notes,
    required this.subject,
  });
}

class NotesResetToNotesFetch extends NotesEvent {
  final List<NotesModel> notes;
  final Subject selectedSubject;

  @override
  List<Object?> get props => [notes];

  const NotesResetToNotesFetch({
    required this.notes,
    required this.selectedSubject,
  });
}

class NotesRatingChanged extends NotesEvent {

  final String ratingAcceptedUserId;
  final UserModel ratingGivenUser;
  final String noteId;
  final double rating;
  final String course;
  final int semester;
  final Subject subject;

  @override
  List<Object?> get props => [rating, noteId, ratingGivenUser, rating, course, semester, subject, ratingAcceptedUserId];

  const NotesRatingChanged({
    required this.ratingAcceptedUserId,
    required this.ratingGivenUser,
    required this.course,
    required this.semester,
    required this.subject,
    required this.rating,
    required this.noteId,
  });

  @override
  String toString() {
    return 'NotesRatingChanged{noteId: $noteId, rating: $rating}';
  }
}

class NotesResetToNotesInitial extends NotesEvent {
  @override
  List<Object?> get props => [];
}

class NotesDelete extends NotesEvent {

  final List<NotesModel> notes;
  final String course;
  final int semester;
  final Subject subject;
  final String noteId;

  @override
  List<Object?> get props => [course, semester, subject, noteId, notes];

  const NotesDelete({
    required this.notes,
    required this.course,
    required this.semester,
    required this.subject,
    required this.noteId,
  });

  @override
  String toString() {
    return 'NotesDelete{course: $course, semester: $semester, subject: $subject, noteId: $noteId}';
  }
}