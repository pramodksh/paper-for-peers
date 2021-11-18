import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';

part 'question_paper_event.dart';
part 'question_paper_state.dart';

class QuestionPaperBloc extends Bloc<QuestionPaperEvent, QuestionPaperState> {

  final FirestoreRepository _firestoreRepository;

  QuestionPaperBloc({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(QuestionPaperInitial()) {
    on<QuestionPaperFetch>((event, emit) async {
      print("EVENT: ${event}");

      emit(QuestionPaperFetchLoading());
      ApiResponse response = await _firestoreRepository.getQuestionPapers(
        course: event.course,
        semester: event.semester,
        subject: event.subject,
      );

      print("GET QUESTION PAPER RES: ${response.isError}");

      if (response.isError) {
        emit(QuestionPaperFetchError(errorMessage: response.errorMessage!));
      } else {
        emit(QuestionPaperFetchSuccess(questionPaperYears: response.data as List<QuestionPaperYearModel>));
      }


    });
  }
}
