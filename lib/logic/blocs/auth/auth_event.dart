part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthUserChanged extends AuthEvent {
  final UserModel user;

  const AuthUserChanged({required this.user});

  @override
  List<Object?> get props => [user];

}