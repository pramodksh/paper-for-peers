import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/text_book.dart';
import 'package:papers_for_peers/data/models/user_model/admin_model.dart';
import 'package:papers_for_peers/data/models/user_model/subject.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/text_book_repository/text_book_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_messaging/firebase_messaging_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_remote_config/firebase_remote_config_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';

part 'text_book_event.dart';
part 'text_book_state.dart';

class TextBookBloc extends Bloc<TextBookEvent, TextBookState> {

  final TextBookRepository _textBookRepository;
  final FilePickerRepository _filePickerRepository;
  final FirebaseRemoteConfigRepository _firebaseRemoteConfigRepository;
  final FirebaseMessagingRepository _firebaseMessagingRepository;
  final FirestoreRepository _firestoreRepository;

  TextBookBloc({
    required TextBookRepository textBookRepository,
    required FilePickerRepository filePickerRepository,
    required FirebaseRemoteConfigRepository firebaseRemoteConfigRepository,
    required FirebaseMessagingRepository firebaseMessagingRepository,
    required FirestoreRepository firestoreRepository,
  }) : _textBookRepository = textBookRepository,
        _filePickerRepository = filePickerRepository,
        _firebaseRemoteConfigRepository = firebaseRemoteConfigRepository,
        _firebaseMessagingRepository = firebaseMessagingRepository,
        _firestoreRepository = firestoreRepository,
        super(TextBookInitial(maxTextBooks: 0)) {

    _firebaseRemoteConfigRepository.getMaxTextBooks().then((maxTextBooks) {
      on<TextBookReportAdd>((event, emit) async {
        print("EVENT: $event");
        ApiResponse reportResponse = await _textBookRepository.reportTextBook(
          course: event.course, semester: event.semester, subject: event.subject.value,
          userId: event.user.uid, textBookId: event.textBookId, reportValues: event.reportValues
        );
        if (reportResponse.isError) {
          emit(TextBookReportError(errorMessage: reportResponse.errorMessage!, maxTextBooks: maxTextBooks));
        } else {
          emit(TextBookReportSuccess(maxTextBooks: maxTextBooks));
        }
        emit(TextBookFetchSuccess(textBookSubjects: event.textBookSubjects, maxTextBooks: maxTextBooks));
      });

      on<TextBookAdd>((event, emit) async {

        File? file = await _filePickerRepository.pickFile();
        if (file != null) {
          emit(TextBookAddLoading(textBookSubjects: event.textBookSubjects, maxTextBooks: maxTextBooks));

          int maxSize = await _firebaseRemoteConfigRepository.getMaxSizeOfTextBook();
          double size = Utils.getFileSizeInMb(file);

          if (size > maxSize) {
            emit(TextBookAddError(errorMessage: "The selected file has exceeded the limit of $maxSize MB.\nThe size of the selected file is ${size.toStringAsFixed(2)} MB",
                textBookSubjects: event.textBookSubjects,
                maxTextBooks: maxTextBooks));
          } else {
            ApiResponse uploadResponse = await _textBookRepository
                .uploadAndAddTextBookToAdmin(
                course: event.course,
                semester: event.semester,
                subject: event.subject.value,
                user: event.user,
                document: file,
                maxTextBooks: maxTextBooks
            );

            if (uploadResponse.isError) {
              emit(TextBookAddError(errorMessage: uploadResponse.errorMessage!,
                  textBookSubjects: event.textBookSubjects,
                  maxTextBooks: maxTextBooks));
            } else {
              emit(TextBookAddSuccess(textBookSubjects: event.textBookSubjects,
                  maxTextBooks: maxTextBooks));

              List<AdminModel> admins = _firestoreRepository.admins;
              Future.forEach<AdminModel>(admins, (admin) async {
                await _firebaseMessagingRepository.sendNotificationIfTokenExists(
                  documentType: DocumentType.TEXT_BOOK,
                  token: admin.fcmToken,
                  userModel: event.user,
                  getFireBaseKey: _firebaseRemoteConfigRepository
                      .getFirebaseKey,
                  semester: event.semester,
                  course: event.course,
                  subject: event.subject,
                );
              });
            }
          }
        }
      });

      on<TextBookFetch>((event, emit) async {
        emit(TextBookFetchLoading(maxTextBooks: maxTextBooks));
        ApiResponse getResponse = await _textBookRepository.getTextBook(course: event.course, semester: event.semester);

        if (getResponse.isError) {
          emit(TextBookFetchError(errorMessage: getResponse.errorMessage!, maxTextBooks: maxTextBooks));
        } else {
          emit(TextBookFetchSuccess(textBookSubjects: getResponse.data, maxTextBooks: maxTextBooks));
        }

      });
    });

  }


}
