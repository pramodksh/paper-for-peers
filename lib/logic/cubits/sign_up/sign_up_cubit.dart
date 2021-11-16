import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';

part 'sign_up_state.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class SignUpCubit extends Cubit<SignUpState> {

  final AuthRepository _authRepository;

  SignUpCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,  super(SignUpState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, signUpStatus: SignUpStatus.initial));
  }

  bool isEmailValid(String email) => email.isValidEmail();

  bool isPasswordValid(String password) => password.isNotEmpty;

  bool isConfirmPasswordValid(String password) => state.password == password;

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, signUpStatus: SignUpStatus.initial));
  }

  void confirmPasswordChanged(String password) {
    emit(state.copyWith(confirmPassword: password, signUpStatus: SignUpStatus.initial));
  }

  void togglePasswordObscure() {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  void toggleConfirmPasswordObscure() {
    emit(state.copyWith(isConfirmPasswordObscure: !state.isConfirmPasswordObscure));
  }

  void signUpWithEmailAndPassword() async {

    print("signUpWithEmailAndPassword");

    if (!state.isValid) {
      print("SIGN UP STATE IS NOT INVALID");
      emit(state.copyWith(signUpStatus: SignUpStatus.error, errorMessage: "Email or Password is invalid"));
      return;
    }

    try {
      emit(state.copyWith(signUpStatus: SignUpStatus.loading));
      ApiResponse signUpResponse = await _authRepository.signUpWithEmailAndPassword(email: state.email, password: state.password);

      if (signUpResponse.isError) {
        emit(state.copyWith(signUpStatus: SignUpStatus.error, errorMessage: signUpResponse.errorMessage));
      } else {
        emit(state.copyWith(signUpStatus: SignUpStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(signUpStatus: SignUpStatus.error, errorMessage: "There was an error while Signing Up: ${e.toString()}"));
    }

  }

}
