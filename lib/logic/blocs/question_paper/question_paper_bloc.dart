import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/question_paper_repository/question_paper_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';

part 'question_paper_event.dart';
part 'question_paper_state.dart';

class QuestionPaperBloc extends Bloc<QuestionPaperEvent, QuestionPaperState> {

  final QuestionPaperRepository _questionPaperRepository;
  final FirebaseStorageRepository _firebaseStorageRepository;
  final FilePickerRepository _filePickerRepository;

  QuestionPaperBloc({
    required QuestionPaperRepository questionPaperRepository,
    required FilePickerRepository filePickerRepository,
    required FirebaseStorageRepository firebaseStorageRepository,
  }) : _questionPaperRepository = questionPaperRepository,
      _filePickerRepository = filePickerRepository,
      _firebaseStorageRepository = firebaseStorageRepository,
      super(QuestionPaperInitial()) {

    on<QuestionPaperFetch>((event, emit) async {
      emit(QuestionPaperFetchLoading());
      ApiResponse response = await _questionPaperRepository.getQuestionPapers(
        course: event.course,
        semester: event.semester,
        subject: event.subject,
      );

      if (response.isError) {
        emit(QuestionPaperFetchError(errorMessage: response.errorMessage!));
      } else {
        emit(QuestionPaperFetchSuccess(questionPaperYears: response.data as List<QuestionPaperYearModel>));
      }

    });


    on<QuestionPaperAdd>((event, emit) async {
      File? file = await _filePickerRepository.pickFile();
      if (file != null) {
        emit(QuestionPaperAddLoading(questionPaperYears: event.questionPaperYears));
        
        ApiResponse addResponse = await _questionPaperRepository.uploadAndAddQuestionPaper(
          version: event.nVersion,
          course: event.course,
          semester: event.semester,
          subject: event.subject,
          year: event.year,
          document: file,
          user: event.user,
        );

        if (addResponse.isError) {
          emit(QuestionPaperAddError(errorMessage: addResponse.errorMessage!, questionPaperYears: event.questionPaperYears));
        } else {
          emit(QuestionPaperAddSuccess(questionPaperYears: event.questionPaperYears));
        }
      }
    });
  }
}
