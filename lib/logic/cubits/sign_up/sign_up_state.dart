part of 'sign_up_cubit.dart';

enum SignUpStatus {
  initial,
  loading,
  success,
  error,
}

extension SignUpStatusExtension on SignUpStatus{
  bool get isLoading => this == SignUpStatus.loading;
  bool get isError => this == SignUpStatus.error;
}

class SignUpState extends Equatable {

  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final SignUpStatus signUpStatus;
  final String errorMessage;

  const SignUpState({
    required this.email,
    required this.password,
    required this.signUpStatus,
    required this.errorMessage,
    required this.confirmPassword,
    required this.isPasswordObscure,
    required this.isConfirmPasswordObscure,
  });

  factory SignUpState.initial() {
    return SignUpState(
      email: "", password: "", confirmPassword: "",
      signUpStatus: SignUpStatus.initial, errorMessage: "",
      isPasswordObscure: true, isConfirmPasswordObscure: true,
    );
  }

  bool get isValid => this.email.isNotEmpty || this.password.isNotEmpty || this.confirmPassword.isNotEmpty;

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    SignUpStatus? signUpStatus,
    String? errorMessage,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      signUpStatus: signUpStatus ?? this.signUpStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure: isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
    );
  }

  @override
  List<Object?> get props => [
    email, password, confirmPassword, signUpStatus, errorMessage,
    isPasswordObscure, isConfirmPasswordObscure,
  ];

}