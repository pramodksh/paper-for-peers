import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/syllabus_copy.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/syllabus_copy_repository/syllabus_copy_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';

part 'syllabus_copy_event.dart';
part 'syllabus_copy_state.dart';

class SyllabusCopyBloc extends Bloc<SyllabusCopyEvent, SyllabusCopyState> {

  final SyllabusCopyRepository _syllabusCopyRepository;
  final FilePickerRepository _filePickerRepository;

  SyllabusCopyBloc({
    required SyllabusCopyRepository syllabusCopyRepository,
    required FilePickerRepository filePickerRepository
  }) : _syllabusCopyRepository = syllabusCopyRepository,
        _filePickerRepository = filePickerRepository ,
        super(SyllabusCopyInitial()) {

    on<SyllabusCopyReportAdd>((event, emit) async {
      print("REPORT: $event");
      ApiResponse reportResponse = await _syllabusCopyRepository.reportSyllabusCopies(userId: event.user.uid, course: event.user.course!.courseName!, semester: event.user.semester!.nSemester!, version: event.version, reportValues: event.reportValues);

      if (reportResponse.isError) {
        emit(SyllabusCopyReportError(errorMessage: reportResponse.errorMessage!));
      } else {
        emit(SyllabusCopyReportSuccess());
      }
      emit(SyllabusCopyFetchSuccess(syllabusCopies: event.syllabusCopies));
    });

    on<SyllabusCopyAdd>((event, emit) async {
      print("ADD : ${event}");

      File? file = await _filePickerRepository.pickFile();
      if (file != null) {
        emit(SyllabusCopyAddLoading(syllabusCopies: event.syllabusCopies));
        ApiResponse uploadAndAddResponse = await  _syllabusCopyRepository.uploadAndAddSyllabusCopy(
          course: event.user.course!.courseName!, semester: event.user.semester!.nSemester!, version: event.version,
          document: file, user: event.user,
        );

        if (uploadAndAddResponse.isError) {
          emit(SyllabusCopyAddError(errorMessage: uploadAndAddResponse.errorMessage!, syllabusCopies: event.syllabusCopies));
        } else {
          emit(SyllabusCopyAddSuccess(syllabusCopies: event.syllabusCopies));
          add(SyllabusCopyFetch(
            course: event.user.course!.courseName!,
            semester: event.user.semester!.nSemester!,
          ));
        }

      }

    });

    on<SyllabusCopyFetch>((event, emit) async {
      print("FETCH: ${event}");

      emit(SyllabusCopyFetchLoading());
      ApiResponse fetchResponse = await _syllabusCopyRepository.getSyllabusCopies(course: event.course, semester: event.semester);

      if (fetchResponse.isError) {
        emit(SyllabusCopyFetchError(errorMessage: fetchResponse.errorMessage!));
      } else {
        List<SyllabusCopyModel> syllabusCopies = fetchResponse.data;
        emit(SyllabusCopyFetchSuccess(syllabusCopies: syllabusCopies));
      }

    });

  }

}
