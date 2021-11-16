import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository _authRepository;
  StreamSubscription<auth.User?>? _userStreamSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository, super(AuthState.unknown()) {

    _userStreamSubscription = _authRepository.user.listen((user) {
      add(AuthUserChanged(user: user!));
    });

    on<AuthUserChanged>((event, emit) {
      emit(AuthState.authenticated(user: event.user));
    });
  }

  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();
    return super.close();
  }
}
