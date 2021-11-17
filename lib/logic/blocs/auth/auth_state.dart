part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unAuthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final UserModel? user;

  const AuthState._({
    this.authStatus = AuthStatus.unknown,
    this.user,
  });

  const AuthState.unknown(): this._();

  const AuthState.authenticated({required UserModel user})
      : this._(authStatus: AuthStatus.authenticated, user: user);

  const AuthState.unAuthenticated()
      : this._(authStatus: AuthStatus.unAuthenticated);

  @override
  List<Object?> get props => [authStatus, user];


}