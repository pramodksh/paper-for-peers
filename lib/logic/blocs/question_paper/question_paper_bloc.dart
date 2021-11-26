import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/question_paper_repository/question_paper_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';

part 'question_paper_event.dart';
part 'question_paper_state.dart';

class QuestionPaperBloc extends Bloc<QuestionPaperEvent, QuestionPaperState> {

  final QuestionPaperRepository _questionPaperRepository;
  final FilePickerRepository _filePickerRepository;

  QuestionPaperBloc({
    required QuestionPaperRepository questionPaperRepository,
    required FilePickerRepository filePickerRepository,
  }) : _questionPaperRepository = questionPaperRepository,
      _filePickerRepository = filePickerRepository,
      super(QuestionPaperInitial()) {

    on<QuestionPaperAddReport>((event, emit) async {
      print("REPORT EVENT: $event");
      ApiResponse reportResponse = await _questionPaperRepository.reportQuestionPaper(
          course: event.course, semester: event.semester, subject: event.subject, 
          year: event.year, nVersion: event.nVersion, reportValues: event.reportValues,
      );

      if (reportResponse.isError) {
        print("QUESTION PAPER REPORT ERROR");
        emit(QuestionPaperReportError(
          errorMessage: reportResponse.errorMessage!,
          selectedSubject: event.subject,
          questionPaperYears: event.questionPaperYears,
        ));
      } else {
        print("QUESTION PAPER REPORT SUCCESS");
        emit(QuestionPaperReportSuccess(
          questionPaperYears: event.questionPaperYears,
          selectedSubject: event.subject,
        ));
      }
      emit(QuestionPaperFetchSuccess(
          questionPaperYears: event.questionPaperYears,
          selectedSubject: event.subject,
      ));

    });

    on<QuestionPaperFetch>((event, emit) async {
      emit(QuestionPaperFetchLoading(selectedSubject: event.subject));
      ApiResponse response = await _questionPaperRepository.getQuestionPapers(
        course: event.course,
        semester: event.semester,
        subject: event.subject,
      );

      if (response.isError) {
        emit(QuestionPaperFetchError(errorMessage: response.errorMessage!, selectedSubject: event.subject));
      } else {
        emit(QuestionPaperFetchSuccess(questionPaperYears: response.data as List<QuestionPaperYearModel>, selectedSubject: event.subject));
      }

    });


    on<QuestionPaperAdd>((event, emit) async {
      File? file = await _filePickerRepository.pickFile();
      if (file != null) {
        emit(QuestionPaperAddLoading(questionPaperYears: event.questionPaperYears, selectedSubject: event.subject));
        
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
          emit(QuestionPaperAddError(errorMessage: addResponse.errorMessage!, questionPaperYears: event.questionPaperYears, selectedSubject: event.subject));
        } else {
          emit(QuestionPaperAddSuccess(questionPaperYears: event.questionPaperYears, selectedSubject: event.subject));
          add(QuestionPaperFetch(
              course: event.course,
              semester: event.semester,
              subject: event.subject,
          ));
        }
      }
    });
  }



}
