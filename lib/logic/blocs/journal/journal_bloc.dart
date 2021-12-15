import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/journal_model.dart';
import 'package:papers_for_peers/data/models/user_model/admin_model.dart';
import 'package:papers_for_peers/data/models/user_model/subject.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/journal_repository/journal_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_messaging/firebase_messaging_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_remote_config/firebase_remote_config_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {

  final JournalRepository _journalRepository;
  final FilePickerRepository _filePickerRepository;
  final FirebaseRemoteConfigRepository _firebaseRemoteConfigRepository;
  final FirebaseMessagingRepository _firebaseMessagingRepository;
  final FirestoreRepository _firestoreRepository;

  JournalBloc({
    required JournalRepository journalRepository,
    required FilePickerRepository filePickerRepository,
    required FirebaseRemoteConfigRepository firebaseRemoteConfigRepository,
    required FirebaseMessagingRepository firebaseMessagingRepository,
    required FirestoreRepository firestoreRepository,
  }) : _journalRepository = journalRepository,
        _filePickerRepository = filePickerRepository,
        _firebaseRemoteConfigRepository = firebaseRemoteConfigRepository,
        _firebaseMessagingRepository = firebaseMessagingRepository,
        _firestoreRepository = firestoreRepository,
        super(JournalInitial(maxJournals: 0)) {

    _firebaseRemoteConfigRepository.getMaxJournals().then((maxJournals) {

      on<JournalReportAdd>((event, emit) async {

        print("REPORT EVENT: $event");
        ApiResponse reportResponse = await _journalRepository.reportJournal(
            course: event.course, semester: event.semester, subject: event.subject.value,
            reportValues: event.reportValues, userId: event.user.uid, journalId: event.journalId,
        );
        if (reportResponse.isError) {
          emit(JournalReportError(errorMessage: reportResponse.errorMessage!, maxJournals: maxJournals));
        } else {
          emit(JournalReportSuccess(maxJournals: maxJournals));
        }
        emit(JournalFetchSuccess(journalSubjects: event.journalSubjects, maxJournals: maxJournals));
      });

      on<JournalAdd>((event, emit) async {

        File? file = await _filePickerRepository.pickFile();
        if (file != null) {
          emit(JournalAddLoading(journalSubjects: event.journalSubjects, maxJournals: maxJournals));

          int maxSize = await _firebaseRemoteConfigRepository.getMaxSizeOfJournal();
          double size = Utils.getFileSizeInMb(file);

          if (size > maxSize) {
            emit(JournalAddError(errorMessage: "The selected file has exceeded the limit of $maxSize MB.\nThe size of the selected file is ${size.toStringAsFixed(2)} MB", journalSubjects: event.journalSubjects, maxJournals: maxJournals));
          } else {
            ApiResponse uploadResponse = await _journalRepository.uploadAndAddJournalToAdmin(
              course: event.course, semester: event.semester, subject: event.subject.value,
              user: event.user,
              document: file, maxJournals: await _firebaseRemoteConfigRepository.getMaxJournals(),
            );
            if (uploadResponse.isError) {
              emit(JournalAddError(errorMessage: uploadResponse.errorMessage!, journalSubjects: event.journalSubjects, maxJournals: maxJournals));
            } else {
              emit(JournalAddSuccess(journalSubjects: event.journalSubjects, maxJournals: maxJournals));

              List<AdminModel> admins = _firestoreRepository.admins;
              Future.forEach<AdminModel>(admins, (admin) async{
                await _firebaseMessagingRepository.sendNotification(
                  documentType: DocumentType.JOURNAL,
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



      on<JournalFetch>((event, emit) async {
        emit(JournalFetchLoading(maxJournals: maxJournals));
        ApiResponse getResponse = await _journalRepository.getJournals(course: event.course, semester: event.semester);

        if (getResponse.isError) {
          emit(JournalFetchError(errorMessage: getResponse.errorMessage!,maxJournals: maxJournals));
        } else {
          emit(JournalFetchSuccess(journalSubjects: getResponse.data, maxJournals: maxJournals));
        }

      });
    });
  }
}
