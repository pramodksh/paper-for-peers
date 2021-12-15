import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/syllabus_copy.dart';
import 'package:papers_for_peers/data/models/user_model/admin_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/syllabus_copy_repository/syllabus_copy_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_messaging/firebase_messaging_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_remote_config/firebase_remote_config_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';

part 'syllabus_copy_event.dart';
part 'syllabus_copy_state.dart';

class SyllabusCopyBloc extends Bloc<SyllabusCopyEvent, SyllabusCopyState> {

  final SyllabusCopyRepository _syllabusCopyRepository;
  final FilePickerRepository _filePickerRepository;
  final FirebaseRemoteConfigRepository _firebaseRemoteConfigRepository;
  final FirestoreRepository _firestoreRepository;
  final FirebaseMessagingRepository _firebaseMessagingRepository;

  SyllabusCopyBloc({
    required SyllabusCopyRepository syllabusCopyRepository,
    required FilePickerRepository filePickerRepository,
    required FirebaseRemoteConfigRepository firebaseRemoteConfigRepository,
    required FirestoreRepository firestoreRepository,
    required FirebaseMessagingRepository firebaseMessagingRepository,
  }) : _syllabusCopyRepository = syllabusCopyRepository,
        _filePickerRepository = filePickerRepository,
        _firestoreRepository = firestoreRepository,
        _firebaseMessagingRepository = firebaseMessagingRepository,
        _firebaseRemoteConfigRepository = firebaseRemoteConfigRepository,
        super(SyllabusCopyInitial(maxSyllabusCopy: 0)) {

    _firebaseRemoteConfigRepository.getMaxSyllabusCopy().then((maxSyllabusCopy) {
      on<SyllabusCopyReportAdd>((event, emit) async {
        print("REPORT: $event");
        ApiResponse reportResponse = await _syllabusCopyRepository.reportSyllabusCopies(
            userId: event.user.uid, course: event.user.course!.courseName!, 
            semester: event.user.semester!.nSemester!, syllabusCopyId: event.syllabusCopyId, 
            reportValues: event.reportValues);

        if (reportResponse.isError) {
          emit(SyllabusCopyReportError(errorMessage: reportResponse.errorMessage!, maxSyllabusCopy: maxSyllabusCopy));
        } else {
          emit(SyllabusCopyReportSuccess(maxSyllabusCopy: maxSyllabusCopy));
        }
        emit(SyllabusCopyFetchSuccess(syllabusCopies: event.syllabusCopies, maxSyllabusCopy: maxSyllabusCopy));
      });

      on<SyllabusCopyAdd>((event, emit) async {
        File? file = await _filePickerRepository.pickFile();
        if (file != null) {
          emit(SyllabusCopyAddLoading(syllabusCopies: event.syllabusCopies, maxSyllabusCopy: maxSyllabusCopy));

          int maxSize = await _firebaseRemoteConfigRepository.getMaxSizeOfSyllabusCopy();
          double size = Utils.getFileSizeInMb(file);

          if (size > maxSize) {
            emit(SyllabusCopyAddError(
                errorMessage: "The selected file has exceeded the limit of $maxSize MB.\nThe size of the selected file is ${size.toStringAsFixed(2)} MB",
                syllabusCopies: event.syllabusCopies,
                maxSyllabusCopy: maxSyllabusCopy));
          } else {
            ApiResponse uploadAndAddResponse = await _syllabusCopyRepository
                .uploadAndAddSyllabusCopyToAdmin(
              course: event.user.course!.courseName!,
              semester: event.user.semester!.nSemester!,
              document: file,
              user: event.user,
              maxSyllabusCopy: maxSyllabusCopy,
            );

            if (uploadAndAddResponse.isError) {
              emit(SyllabusCopyAddError(
                  errorMessage: uploadAndAddResponse.errorMessage!,
                  syllabusCopies: event.syllabusCopies,
                  maxSyllabusCopy: maxSyllabusCopy));
            } else {
              emit(SyllabusCopyAddSuccess(syllabusCopies: event.syllabusCopies,
                  maxSyllabusCopy: maxSyllabusCopy));

              List<AdminModel> admins = _firestoreRepository.admins;
              Future.forEach<AdminModel>(admins, (admin) async {
                await _firebaseMessagingRepository.sendNotificationIfTokenExists(
                  documentType: DocumentType.SYLLABUS_COPY,
                  token: admin.fcmToken,
                  userModel: event.user,
                  getFireBaseKey: _firebaseRemoteConfigRepository
                      .getFirebaseKey,
                  semester: event.user.semester!.nSemester!,
                  course: event.user.course!.courseName!,
                );
              });
            }
          }
        }

      });

      on<SyllabusCopyFetch>((event, emit) async {
        print("FETCH: ${event}");

        emit(SyllabusCopyFetchLoading(maxSyllabusCopy: maxSyllabusCopy));
        ApiResponse fetchResponse = await _syllabusCopyRepository.getSyllabusCopies(course: event.course, semester: event.semester);

        if (fetchResponse.isError) {
          emit(SyllabusCopyFetchError(errorMessage: fetchResponse.errorMessage!, maxSyllabusCopy: maxSyllabusCopy));
        } else {
          List<SyllabusCopyModel> syllabusCopies = fetchResponse.data;
          emit(SyllabusCopyFetchSuccess(syllabusCopies: syllabusCopies, maxSyllabusCopy: maxSyllabusCopy));
        }

      });
    });

  }

}
