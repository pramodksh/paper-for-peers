import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/image_picker/image_picker_repository.dart';
import 'package:papers_for_peers/logic/blocs/journal/journal_bloc.dart';
import 'package:papers_for_peers/logic/blocs/notes/notes_bloc.dart';
import 'package:papers_for_peers/logic/blocs/question_paper/question_paper_bloc.dart';
import 'package:papers_for_peers/logic/blocs/syllabus_copy/syllabus_copy_bloc.dart';
import 'package:papers_for_peers/logic/blocs/text_book/text_book_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {

  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final FirebaseStorageRepository _firebaseStorageRepository;
  final ImagePickerRepository _imagePickerRepository;

  final QuestionPaperBloc _questionPaperBloc;
  final JournalBloc _journalBloc;
  final NotesBloc _notesBloc;
  final SyllabusCopyBloc _syllabusCopyBloc;
  final TextBookBloc _textBookBloc;

  UserCubit({
    required FirestoreRepository firestoreRepository,
    required FirebaseStorageRepository firebaseStorageRepository,
    required ImagePickerRepository imagePickerRepository,
    required AuthRepository authRepository,
    required QuestionPaperBloc questionPaperBloc,
    required JournalBloc journalBloc,
    required NotesBloc notesBloc,
    required SyllabusCopyBloc syllabusCopyBloc,
    required TextBookBloc textBookBloc,
  }) : _firestoreRepository = firestoreRepository,
        _firebaseStorageRepository = firebaseStorageRepository,
        _imagePickerRepository = imagePickerRepository,
        _authRepository = authRepository,
        _questionPaperBloc = questionPaperBloc,
        _journalBloc = journalBloc,
        _notesBloc = notesBloc,
        _syllabusCopyBloc = syllabusCopyBloc,
        _textBookBloc = textBookBloc,
        super(UserInitial());

  Future<bool> sendPasswordResetEmail(String email) async => await _authRepository.sendForgotEmail(email);

  Future<void> reloadUser() async {
    await _authRepository.reloadCurrentUser();
  }

  Future<void> pickImage({required ImageSource imageSource, UserModel? userModel}) async {
    if (userModel == null) {
      userModel = (state as UserEditSuccess).userModel;
    }

    emit(UserEditProfilePhotoLoading());

    File? file = await _imagePickerRepository.getPickedImageAsFile(imageSource: imageSource);

    if (file == null) {
      emit(UserEditSuccess(profilePhotoFile: null, userModel: userModel));
    } else {
      emit(UserEditProfilePhotoLoading());
      File? croppedFile = await _imagePickerRepository.getCroppedImage(imageFile: file);
      emit(UserEditSuccess(profilePhotoFile: croppedFile, userModel: userModel));
    }

  }

  void setUser(UserModel userModel) {
    emit(UserLoaded(userModel: userModel,));
  }

  void initiateUserEdit() {
    UserModel userModel = (state as UserLoaded).userModel;
    emit(UserEditSuccess(profilePhotoFile: null, userModel: userModel));
  }

  void editUserRemoveProfilePhoto() {
    emit(UserEditSuccess(profilePhotoFile: null, userModel: (state as UserEditSuccess).userModel.copyWith(photoUrl: null)));
  }

  void editUser({File? profilePhotoFile, UserModel? userModel,}) {
    emit(
        UserEditSuccess(
          profilePhotoFile: profilePhotoFile ?? (state as UserEditSuccess).profilePhotoFile,
          userModel: userModel ?? (state as UserEditSuccess).userModel
        )
    );
  }

  Future<ApiResponse> addUser(UserModel userModel) async {
    emit(UserLoading());
    ApiResponse addUserResponse = await _firestoreRepository.addUser(user: userModel,);

    if (addUserResponse.isError) {
      emit(UserAddError(errorMessage: addUserResponse.errorMessage!));
    } else {
      emit(UserLoaded(userModel: userModel));
    }
    return addUserResponse;
  }

  Future<void> uploadProfilePhotoToStorage({
    required File file,
    required UserModel user,
  }) async {

    UserModel userModel = (state as UserEditSuccess).userModel;

    emit(UserEditSubmitting(profilePhotoFile: file, userModel: userModel));

    ApiResponse response = await _firebaseStorageRepository.uploadProfilePhotoAndGetUrl(file: file, userId: user.uid);

    if (response.isError) {
      emit(UserAddError(errorMessage: response.errorMessage!));
    } else {
      emit(UserAddSuccess(profilePhotoFile: file, userModel: userModel.copyWith(photoUrl: response.data)));
    }

  }

  Future<bool> isUserExists(UserModel user) async => await _firestoreRepository.isUserExists(userId: user.uid);

  Future<UserModel> getUserById({required String userId}) async => await _firestoreRepository.getUserByUserId(userId: userId);

  Future<void> changeSemesterAndReloadDocuments(Semester semester) async {
    UserModel changedUser = (state as UserLoaded).userModel.copyWith(semester: semester);
    emit(UserLoading());
    ApiResponse response = await _firestoreRepository.addUser(user: changedUser);
    if (response.isError) {
      emit(UserEditError(errorMessage: response.errorMessage!));
    } else {
      emit(UserLoaded(userModel: changedUser));
      _questionPaperBloc.add(QuestionPaperReset());
      _notesBloc.add(NotesResetToNotesInitial());
      _journalBloc.add(JournalFetch(
          course: (state as UserLoaded).userModel.course!.courseName!,
          semester: (state as UserLoaded).userModel.semester!.nSemester!,
      ));
      _syllabusCopyBloc.add(SyllabusCopyFetch(
        course: (state as UserLoaded).userModel.course!.courseName!,
        semester: (state as UserLoaded).userModel.semester!.nSemester!,
      ));
      _textBookBloc.add(TextBookFetch(
        course: (state as UserLoaded).userModel.course!.courseName!,
        semester: (state as UserLoaded).userModel.semester!.nSemester!,
      ));
    }
  }

}
