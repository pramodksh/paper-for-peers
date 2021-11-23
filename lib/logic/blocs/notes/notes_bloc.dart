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

    on<NotesRatingChanged>((event, emit) async {
      await _notesRepository.addRatingToNotes(
        noteId: event.noteId, rating: event.rating, course: event.course,
        semester: event.semester, subject: event.subject, user: event.ratingGivenUser,
      );
      await _notesRepository.addRatingToUser(ratingAcceptedUserId: event.ratingAcceptedUserId, rating: event.rating, noteId: event.noteId);
    });

    on<NotesResetToNotesFetch>((event, emit) {
      emit(NotesFetchSuccess(notes: event.notes, selectedSubject: event.selectedSubject));
    });

    on<NotesAddEdit>((event, emit) async {
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
          add(
              NotesFetch(
                  course: event.user.course!.courseName!,
                  semester: event.user.semester!.nSemester!,
                  subject: event.subject,
              )
          );
        }
      }
    });

    on<NotesFetch>((event, emit) async {
      emit(NotesFetchLoading(selectedSubject: event.subject));
      ApiResponse fetchResponse = await _notesRepository.getNotes(course: event.course, semester: event.semester, subject: event.subject);
      
      if (fetchResponse.isError) {
        emit(NotesFetchError(errorMessage: fetchResponse.errorMessage!, selectedSubject: event.subject));
      } else {
        List<NotesModel> notes = fetchResponse.data;
        print("BLOC LEN: ${notes.length}");
        emit(NotesFetchSuccess(notes: notes, selectedSubject: event.subject));
      }
    });
  }

}
