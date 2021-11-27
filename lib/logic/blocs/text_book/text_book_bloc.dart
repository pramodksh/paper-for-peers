import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/document_models/text_book.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/text_book_repository/text_book_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';

part 'text_book_event.dart';
part 'text_book_state.dart';

class TextBookBloc extends Bloc<TextBookEvent, TextBookState> {

  final TextBookRepository _textBookRepository;
  final FilePickerRepository _filePickerRepository;

  TextBookBloc({
    required TextBookRepository textBookRepository,
    required FilePickerRepository filePickerRepository
  }) : _textBookRepository = textBookRepository,
        _filePickerRepository = filePickerRepository ,
        super(TextBookInitial()) {

    on<TextBookReportAdd>((event, emit) async {
      print("EVENT: $event");
      ApiResponse reportResponse = await _textBookRepository.reportTextBook(course: event.course, semester: event.semester, subject: event.subject, userId: event.user.uid, version: event.nVersion, reportValues: event.reportValues);
      if (reportResponse.isError) {
        emit(TextBookReportError(errorMessage: reportResponse.errorMessage!));
      } else {
        emit(TextBookReportSuccess());
      }
      emit(TextBookFetchSuccess(textBookSubjects: event.textBookSubjects));
    });

    on<TextBookAdd>((event, emit) async {

      File? file = await _filePickerRepository.pickFile();
      if (file != null) {
        emit(TextBookAddLoading(textBookSubjects: event.textBookSubjects));

        ApiResponse uploadResponse = await _textBookRepository.uploadAndAddTextBook(
          course: event.course, semester: event.semester, subject: event.subject,
          user: event.user, version: event.nVersion,
          document: file,
        );

        if (uploadResponse.isError) {
          emit(TextBookAddError(errorMessage: uploadResponse.errorMessage!, textBookSubjects: event.textBookSubjects));
        } else {
          emit(TextBookAddSuccess(textBookSubjects: event.textBookSubjects));
          add(
              TextBookFetch(
                course: event.course,
                semester: event.semester,
              )
          );
        }

      }
    });

    on<TextBookFetch>((event, emit) async {
      emit(TextBookFetchLoading());
      ApiResponse getResponse = await _textBookRepository.getTextBook(course: event.course, semester: event.semester);

      if (getResponse.isError) {
        emit(TextBookFetchError(errorMessage: getResponse.errorMessage!,));
      } else {
        emit(TextBookFetchSuccess(textBookSubjects: getResponse.data));
      }

    });

  }


}
