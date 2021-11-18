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

  bool get isValidCourse => userModel.course != null;

  bool get isValidSemester => userModel.semester != null;

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

class UserEditSuccess extends UserState {
  final File? profilePhotoFile;
  final UserModel userModel;

  UserEditSuccess({required this.profilePhotoFile, required this.userModel});

  @override
  List<Object?> get props => [profilePhotoFile, userModel];
}

class UserEditLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserEditError extends UserState {

  final String errorMessage;

  UserEditError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}