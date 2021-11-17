import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';

part 'google_auth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final AuthRepository _authRepository;

  GoogleAuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository, super(GoogleAuthState.initial());

  void authenticateWithGoogle() async {
    emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.loading));
    ApiResponse googleAuthResponse = await _authRepository.authenticateWithGoogle();

    if (googleAuthResponse.isError) {
      emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.error, errorMessage: googleAuthResponse.errorMessage));
    } else {
      emit(state.copyWith(googleAuthStatus: GoogleAuthStatus.success));
    }
  }

}
