import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/services/firebase_firestore/firebase_firestore_service.dart';

part 'course_and_semester_state.dart';

class CourseAndSemesterCubit extends Cubit<CourseAndSemesterState> {
  CourseAndSemesterCubit() : super(CourseAndSemesterInitial());

  void fetchCourses() async {
    emit(CourseAndSemesterLoading());
    List<Course> courses = await FirebaseFireStoreService().getCourses();
    emit(CourseAndSemesterLoaded(courses: courses));
  }

}
