part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

class NotesFetch extends NotesEvent {
  final String course;
  final int semester;
  final String subject;

  @override
  List<Object?> get props => [course, semester, subject,];

  const NotesFetch({
    required this.course,
    required this.semester,
    required this.subject,
  });
}

class NotesAddEdit extends NotesEvent {

  final String subject;
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
  final String subject;

  @override
  List<Object?> get props => [title, description, user, subject];

  const NotesAdd({
    required this.file,
    required this.title,
    required this.description,
    required this.user,
    required this.subject,
  });

  @override
  String toString() {
    return 'NotesAdd{file: $file, title: $title, description: $description, user: $user, subject: $subject}';
  }
}