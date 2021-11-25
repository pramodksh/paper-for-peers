import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/shared_preference/shared_preference_repository.dart';

part 'google_auth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final SharedPreferenceRepository _sharedPreferenceRepository;

  GoogleAuthCubit({required AuthRepository authRepository, required FirestoreRepository firestoreRepository, required SharedPreferenceRepository sharedPreferenceRepository})
      : _authRepository = authRepository,
        _firestoreRepository = firestoreRepository,
        _sharedPreferenceRepository = sharedPreferenceRepository,
        super(GoogleAuthState(
            googleAuthStatus: GoogleAuthStatus.initial, isCoursesLoading: false,
        ));

  Future<void> setCourses() async {
    emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.initial, isCoursesLoading: true));
    List<Course> courses = await _firestoreRepository.getCourses();
    emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.initial, isCoursesLoading: false, courses: courses));

  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.loading));
    ApiResponse googleAuthResponse = await _authRepository.authenticateWithGoogle();

    if (googleAuthResponse.isError) {
      emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.error, errorMessage: googleAuthResponse.errorMessage));
    } else {

      UserModel userModel = googleAuthResponse.data['userModel'];
      bool isNewUser = googleAuthResponse.data['isNewUser'];
      print("GOOGLE AUTH: $isNewUser");

      // if (isSignIn == false) {
      //   // todo signup, show courses and semester and add to database
      // } else {
      //   // todo sign in
      // }

      emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.success));
    }
  }

  Future<void>? signUpWithGoogle({required Course course, required Semester semester}) async {
    print("SELECTED COURSE: ${course.courseName} || ${semester.nSemester}");
  }

  void authenticateWithGoogle({required bool isSignIn}) async {
    emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.loading));

    ApiResponse googleAuthResponse = await _authRepository.authenticateWithGoogle();

    if (googleAuthResponse.isError) {
      emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.error, errorMessage: googleAuthResponse.errorMessage));
    } else {

      UserModel userModel = googleAuthResponse.data;
      bool isUserExists = await _firestoreRepository.isUserExists(userId: userModel.uid);
      print("GOOGLE AUTH: $isUserExists");

      if (!isUserExists) {
        await _sharedPreferenceRepository.setIsShowIntroScreen(true);
        ApiResponse addResponse = await _firestoreRepository.addUser(user: userModel);

        if (addResponse.isError){
          print("ADD ERROR: ${addResponse.errorMessage}");
        } else {
          print("USER ADDED TO DATABASE");
        }
      } else {
        _sharedPreferenceRepository.setIsShowIntroScreen(false);
      }

      emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.success, ));
    }
  }

}
