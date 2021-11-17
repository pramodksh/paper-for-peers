part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {

  final UserModel userModel;

  UserLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];

}

class UserLoading extends UserState {

  @override
  List<Object?> get props => [];
}

class UserError extends UserState {

  final String errorMessage;

  UserError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

}