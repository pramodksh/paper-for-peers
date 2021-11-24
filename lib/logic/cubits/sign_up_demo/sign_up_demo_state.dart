part of 'sign_up_demo_cubit.dart';

enum SignUpDemoStateStatus {
  initial,
  loading,
  error,
  success,
}

extension SignUpDemoStateStatusExtension on SignUpDemoStateStatus {
  bool get isInitial => this == SignUpDemoStateStatus.initial;
  bool get isLoading => this == SignUpDemoStateStatus.loading;
  bool get isError => this == SignUpDemoStateStatus.error;
  bool get isSuccess => this == SignUpDemoStateStatus.success;
}

class SignUpDemoState {

  final List<Course>? courses;
  final bool isCoursesLoading;

  final SignUpDemoStateStatus signUpDemoStateStatus;

  final Course? selectedCourse;
  final Semester? selectedSemester;
  final String? errorMessage;
  final String? email;
  final String? username;

  final File? profilePhotoFile;
  final bool isProfilePhotoLoading;

  final String? password;
  final String? confirmPassword;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;

  const SignUpDemoState({
    required this.isCoursesLoading,
    this.courses,
    required this.signUpDemoStateStatus,
    this.selectedCourse,
    this.selectedSemester,
    this.errorMessage,
    this.email,
    this.username,
    this.profilePhotoFile,
    required this.isProfilePhotoLoading,
    this.password,
    this.confirmPassword,
    required this.isPasswordObscure,
    required this.isConfirmPasswordObscure,
  });

  // profilePhotoFile: profilePhotoFile,
  // and not
  // profilePhotoFile: profilePhotoFile ?? this.profilePhotoFile,
  // because user can remove profile photo

  SignUpDemoState copyWith({
    List<Course>? courses,
    bool? isCoursesLoading,
    SignUpDemoStateStatus? signUpDemoStateStatus,
    Course? selectedCourse,
    Semester? selectedSemester,
    String? errorMessage,
    String? email,
    String? username,
    File? profilePhotoFile,
    bool isProfilePhotoReset = false,
    bool? isProfilePhotoLoading,
    String? password,
    String? confirmPassword,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    return SignUpDemoState(
      courses: courses ?? this.courses,
      isCoursesLoading: isCoursesLoading ?? this.isCoursesLoading,
      signUpDemoStateStatus:
          signUpDemoStateStatus ?? this.signUpDemoStateStatus,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedSemester: selectedSemester ?? this.selectedSemester,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePhotoFile: isProfilePhotoReset ? null : profilePhotoFile ?? this.profilePhotoFile,
      isProfilePhotoLoading:
          isProfilePhotoLoading ?? this.isProfilePhotoLoading,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
    );
  }

  @override
  String toString() {
    return 'SignUpDemoState{courses: $courses, isCoursesLoading: $isCoursesLoading, signUpDemoStateStatus: $signUpDemoStateStatus, selectedCourse: $selectedCourse, selectedSemester: $selectedSemester, errorMessage: $errorMessage, email: $email, username: $username, profilePhotoFile: $profilePhotoFile, isProfilePhotoLoading: $isProfilePhotoLoading, password: $password, confirmPassword: $confirmPassword, isPasswordObscure: $isPasswordObscure, isConfirmPasswordObscure: $isConfirmPasswordObscure}';
  }
}