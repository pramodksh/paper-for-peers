import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';

part 'sign_in_state.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}


class SignInCubit extends Cubit<SignInState> {

  final AuthRepository _authRepository;

  SignInCubit({required AuthRepository authRepository})
      : _authRepository = authRepository, super(SignInState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, signInStatus: SignInStatus.initial));
  }

  bool isEmailValid(String email) => email.isValidEmail();

  bool isPasswordValid(String password) => password.isNotEmpty;

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, signInStatus: SignInStatus.initial));
  }

  void togglePasswordObscure() {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  void buttonClicked() async {
    print("signInWithEmailAndPassword");

    if (!state.isValid) {
      print("SIGN In STATE IS NOT INVALID");
      emit(state.copyWith(signInStatus: SignInStatus.error, errorMessage: "Email or Password is invalid"));
      return;
    }

    try {
      emit(state.copyWith(signInStatus: SignInStatus.loading));
      ApiResponse signUpResponse = await _authRepository.signInWithEmailAndPassword(email: state.email, password: state.password);

      if (signUpResponse.isError) {
        emit(state.copyWith(signInStatus: SignInStatus.error, errorMessage: signUpResponse.errorMessage));
      } else {
        emit(state.copyWith(signInStatus: SignInStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(signInStatus: SignInStatus.error, errorMessage: "There was an error while Signing In: ${e.toString()}"));
    }
  }

}
