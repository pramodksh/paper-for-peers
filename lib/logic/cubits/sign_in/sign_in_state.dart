part of 'sign_in_cubit.dart';

enum SignInStatus {
  initial,
  loading,
  success,
  error,
}

class SignInState extends Equatable {

  final String email;
  final String password;
  final bool isPasswordObscure;
  final SignInStatus signInStatus;
  final String errorMessage;

  const SignInState({
    required this.email,
    required this.password,
    required this.signInStatus,
    required this.errorMessage,
    required this.isPasswordObscure,
  });

  factory SignInState.initial() {
    return SignInState(
      email: "", password: "", isPasswordObscure: true,
      signInStatus: SignInStatus.initial, errorMessage: "",
    );
  }

  bool get isValid => this.email.isNotEmpty || this.password.isNotEmpty;


  @override
  List<Object?> get props => [email, password, isPasswordObscure, signInStatus, errorMessage,];

  SignInState copyWith({
    String? email,
    String? password,
    bool? isPasswordObscure,
    SignInStatus? signInStatus,
    String? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      signInStatus: signInStatus ?? this.signInStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}