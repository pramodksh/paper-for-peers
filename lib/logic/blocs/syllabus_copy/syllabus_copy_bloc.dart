import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/syllabus_copy.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/syllabus_copy_repository/syllabus_copy_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_remote_config/firebase_remote_config_repository.dart';

part 'syllabus_copy_event.dart';
part 'syllabus_copy_state.dart';

class SyllabusCopyBloc extends Bloc<SyllabusCopyEvent, SyllabusCopyState> {

  final SyllabusCopyRepository _syllabusCopyRepository;
  final FilePickerRepository _filePickerRepository;
  final FirebaseRemoteConfigRepository _firebaseRemoteConfigRepository;

  SyllabusCopyBloc({
    required SyllabusCopyRepository syllabusCopyRepository,
    required FilePickerRepository filePickerRepository,
    required FirebaseRemoteConfigRepository firebaseRemoteConfigRepository,
  }) : _syllabusCopyRepository = syllabusCopyRepository,
        _filePickerRepository = filePickerRepository,
        _firebaseRemoteConfigRepository = firebaseRemoteConfigRepository,
        super(SyllabusCopyInitial(maxSyllabusCopy: 0)) {

    _firebaseRemoteConfigRepository.getMaxSyllabusCopy().then((maxSyllabusCopy) {
      on<SyllabusCopyReportAdd>((event, emit) async {
        print("REPORT: $event");
        ApiResponse reportResponse = await _syllabusCopyRepository.reportSyllabusCopies(userId: event.user.uid, course: event.user.course!.courseName!, semester: event.user.semester!.nSemester!, version: event.version, reportValues: event.reportValues);

        if (reportResponse.isError) {
          emit(SyllabusCopyReportError(errorMessage: reportResponse.errorMessage!, maxSyllabusCopy: maxSyllabusCopy));
        } else {
          emit(SyllabusCopyReportSuccess(maxSyllabusCopy: maxSyllabusCopy));
        }
        emit(SyllabusCopyFetchSuccess(syllabusCopies: event.syllabusCopies, maxSyllabusCopy: maxSyllabusCopy));
      });

      on<SyllabusCopyAdd>((event, emit) async {
        print("ADD : ${event}");

        File? file = await _filePickerRepository.pickFile();
        if (file != null) {
          emit(SyllabusCopyAddLoading(syllabusCopies: event.syllabusCopies, maxSyllabusCopy: maxSyllabusCopy));
          ApiResponse uploadAndAddResponse = await  _syllabusCopyRepository.uploadAndAddSyllabusCopy(
            course: event.user.course!.courseName!, semester: event.user.semester!.nSemester!, version: event.version,
            document: file, user: event.user, maxSyllabusCopy: maxSyllabusCopy
          );

          if (uploadAndAddResponse.isError) {
            emit(SyllabusCopyAddError(errorMessage: uploadAndAddResponse.errorMessage!, syllabusCopies: event.syllabusCopies, maxSyllabusCopy: maxSyllabusCopy));
          } else {
            emit(SyllabusCopyAddSuccess(syllabusCopies: event.syllabusCopies, maxSyllabusCopy: maxSyllabusCopy));
            add(SyllabusCopyFetch(
              course: event.user.course!.courseName!,
              semester: event.user.semester!.nSemester!,
            ));
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
