part of 'google_auth_cubit.dart';

enum GoogleAuthStatus {
  initial,
  loading,
  success,
  error,
}

extension GoogleAuthStatusExtension on GoogleAuthStatus {
  bool get isLoading => this == GoogleAuthStatus.loading;
  bool get isError => this == GoogleAuthStatus.error;
}

class GoogleAuthState extends Equatable {

  final List<Course>? courses;
  final bool isCoursesLoading;

  final Course? selectedCourse;
  final Semester? selectedSemester;

  final GoogleAuthStatus googleAuthStatus;
  final String? errorMessage;

  const GoogleAuthState({
    required this.googleAuthStatus,
    this.errorMessage,
    this.selectedSemester,
    this.selectedCourse,
    this.courses,
    required this.isCoursesLoading,
  });

  @override
  List<Object?> get props => [googleAuthStatus, errorMessage];

  GoogleAuthState copyWith({
    List<Course>? courses,
    bool? isCoursesLoading,
    Course? selectedCourse,
    Semester? selectedSemester,
    GoogleAuthStatus? googleAuthStatus,
    String? errorMessage,
  }) {
    return GoogleAuthState(
      courses: courses ?? this.courses,
      isCoursesLoading: isCoursesLoading ?? this.isCoursesLoading,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedSemester: selectedSemester ?? this.selectedSemester,
      googleAuthStatus: googleAuthStatus ?? this.googleAuthStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}