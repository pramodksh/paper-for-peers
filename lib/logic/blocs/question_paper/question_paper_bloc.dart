import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/data/models/user_model/admin_model.dart';
import 'package:papers_for_peers/data/models/user_model/subject.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/question_paper_repository/question_paper_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_messaging/firebase_messaging_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_remote_config/firebase_remote_config_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';

part 'question_paper_event.dart';
part 'question_paper_state.dart';

class QuestionPaperBloc extends Bloc<QuestionPaperEvent, QuestionPaperState> {

  final QuestionPaperRepository _questionPaperRepository;
  final FilePickerRepository _filePickerRepository;
  final FirebaseRemoteConfigRepository _firebaseRemoteConfigRepository;
  final FirebaseMessagingRepository _firebaseMessagingRepository;
  final FirestoreRepository _firestoreRepository;

  QuestionPaperBloc({
    required QuestionPaperRepository questionPaperRepository,
    required FilePickerRepository filePickerRepository,
    required FirebaseRemoteConfigRepository firebaseRemoteConfigRepository,
    required FirebaseMessagingRepository firebaseMessagingRepository,
    required FirestoreRepository firestoreRepository,
  }) : _questionPaperRepository = questionPaperRepository,
      _filePickerRepository = filePickerRepository,
      _firebaseRemoteConfigRepository = firebaseRemoteConfigRepository,
      _firebaseMessagingRepository = firebaseMessagingRepository,
      _firestoreRepository = firestoreRepository,
      super(QuestionPaperInitial(maxQuestionPapers: 0)) {

    _firebaseRemoteConfigRepository.getMaxQuestionPapers().then((maxQuestionPapers) {
      on<QuestionPaperReset>((event, emit) {
        emit(QuestionPaperInitial(maxQuestionPapers: maxQuestionPapers));
      });

      on<QuestionPaperAddReport>((event, emit) async {
        print("REPORT EVENT: $event");
        ApiResponse reportResponse = await _questionPaperRepository.reportQuestionPaper(
          course: event.course, semester: event.semester, subject: event.subject.value,
          year: event.year, reportValues: event.reportValues,
          userId: event.userId, questionPaperId: event.questionPaperId
        );

        if (reportResponse.isError) {
          print("QUESTION PAPER REPORT ERROR");
          emit(QuestionPaperReportError(
            errorMessage: reportResponse.errorMessage!,
            selectedSubject: event.subject,
            questionPaperYears: event.questionPaperYears,
            maxQuestionPapers: maxQuestionPapers,
          ));
        } else {
          print("QUESTION PAPER REPORT SUCCESS");
          emit(QuestionPaperReportSuccess(
            questionPaperYears: event.questionPaperYears,
            selectedSubject: event.subject,
            maxQuestionPapers: maxQuestionPapers,
          ));
        }
        emit(QuestionPaperFetchSuccess(
          questionPaperYears: event.questionPaperYears,
          selectedSubject: event.subject,
          maxQuestionPapers: maxQuestionPapers,
        ));

      });

      on<QuestionPaperFetch>((event, emit) async {
        emit(QuestionPaperFetchLoading(selectedSubject: event.subject, maxQuestionPapers: maxQuestionPapers));
        ApiResponse response = await _questionPaperRepository.getQuestionPapers(
          course: event.course,
          semester: event.semester,
          subject: event.subject.value,
        );

        if (response.isError) {
          emit(QuestionPaperFetchError(errorMessage: response.errorMessage!, selectedSubject: event.subject, maxQuestionPapers: maxQuestionPapers));
        } else {
          emit(QuestionPaperFetchSuccess(questionPaperYears: response.data as List<QuestionPaperYearModel>, selectedSubject: event.subject, maxQuestionPapers: maxQuestionPapers));
        }

      });


      on<QuestionPaperAdd>((event, emit) async {
        File? file = await _filePickerRepository.pickFile();
        if (file != null) {
          emit(QuestionPaperAddLoading(questionPaperYears: event.questionPaperYears, selectedSubject: event.subject, maxQuestionPapers: maxQuestionPapers));

          int maxSize = await _firebaseRemoteConfigRepository.getMaxSizeOfQuestionPaper();
          double size = Utils.getFileSizeInMb(file);

          if (size > maxSize) {
            emit(QuestionPaperAddError(
                errorMessage: "The selected file has exceeded the limit of $maxSize MB.\nThe size of the selected file is ${size.toStringAsFixed(2)} MB",
                questionPaperYears: event.questionPaperYears,
                selectedSubject: event.subject,
                maxQuestionPapers: maxQuestionPapers));
          } else {
            ApiResponse uploadResponse = await _questionPaperRepository.uploadAndAddQuestionPaperToAdmin(
                course: event.course,
                semester: event.semester,
                subject: event.subject.value,
                year: event.year,
                document: file,
                user: event.user,
                maxQuestionPapers: maxQuestionPapers
            );

            if (uploadResponse.isError) {
              emit(QuestionPaperAddError(
                  errorMessage: uploadResponse.errorMessage!,
                  questionPaperYears: event.questionPaperYears,
                  selectedSubject: event.subject,
                  maxQuestionPapers: maxQuestionPapers));
            } else {
              emit(QuestionPaperAddSuccess(
                  questionPaperYears: event.questionPaperYears,
                  selectedSubject: event.subject,
                  maxQuestionPapers: maxQuestionPapers));

              List<AdminModel> admins = _firestoreRepository.admins;
              Future.forEach<AdminModel>(admins, (admin) async {

                log("CHECK TOKEN, ${admin.fcmToken}");

                await _firebaseMessagingRepository.sendNotificationIfTokenExists(
                  documentType: DocumentType.QUESTION_PAPER,
                  token: admin.fcmToken,
                  userModel: event.user,
                  getFireBaseKey: _firebaseRemoteConfigRepository.getFirebaseKey,
                  semester: event.semester,
                  course: event.course,
                  subject: event.subject,
                );
              });
            }
          }
        }
      });
    });


  }



}
