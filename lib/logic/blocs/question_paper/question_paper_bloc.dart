import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/question_paper_repository/question_paper_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';

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

      print("${event}");

      // todo pick file
      // emit(QuestionPaperAddLoading());
      File? file = await _filePickerRepository.pickFile();

      print("FILE IS $file");

      if (file == null) {
        emit(QuestionPaperAddCanceled());
      } else {
        // todo get url by uploading to storage
        ApiResponse storageResponse = await _firebaseStorageRepository.uploadQuestionPaper(
          document: file, year: event.year, subject: event.subject,
          semester: event.semester, course: event.course, version: event.nVersion,
        );

        if (storageResponse.isError) {
          print("YO STORAGE ERROR");
          emit(QuestionPaperAddError(errorMessage: storageResponse.errorMessage!));
        } else {
          print("YO CHECK STORAGE");

          // todo upload to firebase database with url
          String documentUrl = storageResponse.data;
        }
      }

    });


  }

}
