import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/image_picker/image_picker_repository.dart';

part 'sign_up_demo_state.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class SignUpDemoCubit extends Cubit<SignUpDemoState> {

  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final ImagePickerRepository _imagePickerRepository;
  final FirebaseStorageRepository _firebaseStorageRepository;

  SignUpDemoCubit({
    required AuthRepository authRepository, required FirestoreRepository firestoreRepository,
    required ImagePickerRepository imagePickerRepository, required FirebaseStorageRepository firebaseStorageRepository,
  }) : _authRepository = authRepository,
        _firestoreRepository = firestoreRepository,
        _imagePickerRepository = imagePickerRepository,
        _firebaseStorageRepository = firebaseStorageRepository,
      super(SignUpDemoState(
          isPasswordObscure: true, isConfirmPasswordObscure: true,
          signUpDemoStateStatus: SignUpDemoStateStatus.initial, isCoursesLoading: false,
        isProfilePhotoLoading: false
      )) {
    initiateSignUp();
  }

  void initiateSignUp() async {
    emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.initial, isCoursesLoading: true));
    List<Course> courses = await _firestoreRepository.getCourses();
    emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.initial, isCoursesLoading: false, courses: courses));
  }

  void courseChanged(Course course) {
    emit(state.copyWith(
      selectedCourse: course,
    ));
  }

  void semesterChanged(Semester semester) {
    emit(state.copyWith(
      selectedSemester: semester,
    ));
  }

  void passwordObscureToggle() {
    emit(state.copyWith(
      isPasswordObscure: !state.isPasswordObscure,
    ));
  }

  void confirmPasswordObscureToggle() {
    emit(state.copyWith(
      isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
    ));
  }

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
    ));
  }

  void confirmPasswordChanged(String confirmPassword) {
    emit(state.copyWith(
      confirmPassword: confirmPassword,
    ));
  }

  void usernameChanged(String username) {
    emit(state.copyWith(
      username: username,
    ));
  }

  bool isEmailValid(String email) => email.isValidEmail();
  bool isPasswordValid(String password) => password.isNotEmpty;
  bool isConfirmPasswordValid(String password) => state.password == password;
  bool isUsernameValid(String username) => username.isNotEmpty;

  Future<void> pickImage({required ImageSource imageSource,}) async {

    emit(state.copyWith(isProfilePhotoLoading: true));

    File? file = await _imagePickerRepository.getPickedImageAsFile(imageSource: imageSource);

    if (file == null) {
      emit(state.copyWith(isProfilePhotoLoading: false));
    } else {
      File? croppedFile = await _imagePickerRepository.getCroppedImage(imageFile: file);
      emit(state.copyWith(isProfilePhotoLoading: false, profilePhotoFile: croppedFile));
    }

  }

  void removeUserPhoto() {
    emit(state.copyWith(isProfilePhotoReset: true));
  }

  void resetErrorToSuccess() {
    emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.success));
  }


  Future<void> buttonClicked() async {
    if (state.selectedCourse == null) {
      emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.error, errorMessage: "Please select your Course"));
      return;
    }

    if (state.selectedSemester == null) {
      emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.error, errorMessage: "Please select your Semester"));
      return;
    }

    print("BUTTON CLICKED:");

    emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.loading));

    ApiResponse signUpResponse = await _authRepository.signUpWithEmailAndPassword(email: state.email!, password: state.password!);
    if (signUpResponse.isError) {
      emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.error, errorMessage: signUpResponse.errorMessage));
      return;
    }

    UserModel userModel = signUpResponse.data;

    late String? photoUrl;
    if (state.profilePhotoFile == null) {
      photoUrl = null;
    } else {
      ApiResponse uploadResponse = await _firebaseStorageRepository.uploadProfilePhotoAndGetUrl(file: state.profilePhotoFile!, userId: userModel.uid,);
      if (uploadResponse.isError) {
        emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.error, errorMessage: uploadResponse.errorMessage));
        return;
      } else {
        photoUrl = uploadResponse.data;
      }
    }

    ApiResponse addResponse = await _firestoreRepository.addUser(user: userModel.copyWith(
      displayName: state.username,
      photoUrl: photoUrl,
      course: state.selectedCourse,
      semester: state.selectedSemester,
    ));

    if (addResponse.isError) {
      emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.error, errorMessage: addResponse.errorMessage));
      return;
    }
    emit(state.copyWith(signUpDemoStateStatus: SignUpDemoStateStatus.success));
  }
}
