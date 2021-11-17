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
  final GoogleAuthStatus googleAuthStatus;
  final String errorMessage;

  const GoogleAuthState({
    required this.googleAuthStatus,
    required this.errorMessage,
  });

  factory GoogleAuthState.initial() {
    return GoogleAuthState(googleAuthStatus: GoogleAuthStatus.initial, errorMessage: "");
  }

  @override
  List<Object?> get props => [googleAuthStatus, errorMessage];

  GoogleAuthState copyWith({
    GoogleAuthStatus? googleAuthStatus,
    String? errorMessage,
  }) {
    return GoogleAuthState(
      googleAuthStatus: googleAuthStatus ?? this.googleAuthStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}