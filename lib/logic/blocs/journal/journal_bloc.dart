import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/journal_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/journal_repository/journal_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {

  final JournalRepository _journalRepository;
  final FilePickerRepository _filePickerRepository;

  JournalBloc({
    required JournalRepository journalRepository,
    required FilePickerRepository filePickerRepository
  }) : _journalRepository = journalRepository,
        _filePickerRepository = filePickerRepository ,
        super(JournalInitial()) {
    on<JournalFetch>((event, emit) async {

      print("FETCH JOURNAL: ${event}");


      emit(JournalFetchLoading());
      ApiResponse getResponse = await _journalRepository.getJournals(course: event.course, semester: event.semester);

      if (getResponse.isError) {
        emit(JournalFetchError(errorMessage: getResponse.errorMessage!,));
      } else {
        emit(JournalFetchSuccess(journalSubjects: getResponse.data));
      }

    });
  }
}
