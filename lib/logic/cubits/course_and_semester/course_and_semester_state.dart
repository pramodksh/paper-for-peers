part of 'course_and_semester_cubit.dart';

abstract class CourseAndSemesterState extends Equatable {
  const CourseAndSemesterState();
}

class CourseAndSemesterInitial extends CourseAndSemesterState {
  @override
  List<Object> get props => [];
}

class CourseAndSemesterLoading extends CourseAndSemesterState {
  @override
  List<Object> get props => [];
}

class CourseAndSemesterLoaded extends CourseAndSemesterState {

  final List<Course> courses;

  CourseAndSemesterLoaded({required this.courses});

  @override
  List<Object> get props => [courses];
}

class CourseAndSemesterError extends CourseAndSemesterState {
  final String errorMessage;

  CourseAndSemesterError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}