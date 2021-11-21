import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

    on<NotesAdd>((event, emit) {
      print("NOTES ADD: ${event}");
    });

    on<NotesFetch>((event, emit) async {

      print("FETCH: ${event}");

      emit(NotesFetchLoading(selectedSubject: event.subject));
      await Future.delayed(Duration(seconds: 3));
      emit(NotesFetchSuccess(notes: [], selectedSubject: event.subject));
    });

  }

}
