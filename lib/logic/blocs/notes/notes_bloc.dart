import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/notes_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/notes_repository/notes_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {

  final NotesRepository _notesRepository;
  final FilePickerRepository _filePickerRepository;

  NotesBloc({
    required NotesRepository notesRepository,
    required FilePickerRepository filePickerRepository,
  }) : _notesRepository = notesRepository,
        _filePickerRepository = filePickerRepository,
        super(NotesInitial()) {



    on<NotesAddEdit>((event, emit) async {
      print("NOTES EDIT: ${event}");

      if (state is! NotesAddEditing) {
        emit(NotesAddEditing(selectedSubject: event.subject, file: null, description: event.description, title: event.title));
      }

      if (event.isFileEdit) {
        File? file = await _filePickerRepository.pickFile();
        emit(NotesAddEditing(selectedSubject: event.subject, file: file, description: event.description, title: event.title));
      } else {
        emit(NotesAddEditing(selectedSubject: event.subject, file: (state as NotesAddEditing).file, description: event.description, title: event.title));
      }

    });

    on<NotesAdd>((event, emit) async {
      print("NOTES ADD: ${event}");

      if (event.file == null) {
        emit(NotesAddError(
            errorMessage: "Please select a file", selectedSubject: event.subject,
            file: null, title: event.title, description: event.description,
        ));
      } else {

        emit(NotesAddLoading(selectedSubject: event.subject));

        ApiResponse uploadResponse = await _notesRepository.uploadAndAddNotes(
          description: event.description,
          title: event.title,
          user: event.user,
          subject: event.subject,
          course: event.user.course!.courseName!,
          semester: event.user.semester!.nSemester!,
          document: event.file!,
        );

        if (uploadResponse.isError) {
          emit(NotesAddError(
            errorMessage: uploadResponse.errorMessage!, selectedSubject: event.subject,
            file: null, title: event.title, description: event.description,
          ));
        } else {
          emit(NotesAddSuccess(
            selectedSubject: event.subject, title: event.title,
            description: event.description, file: event.file,
          ));
        }

        print("UPLOAD FILE");

        print("ADD TO DATABASE");
      }

    });

    on<NotesFetch>((event, emit) async {

      print("FETCH: ${event}");

      emit(NotesFetchLoading(selectedSubject: event.subject));
      await Future.delayed(Duration(seconds: 3));
      emit(NotesFetchSuccess(notes: [], selectedSubject: event.subject));
    });

  }

}
