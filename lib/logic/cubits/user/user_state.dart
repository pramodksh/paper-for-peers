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

class UserAddError extends UserState {

  final String errorMessage;

  UserAddError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

}

class UserAddSuccess extends UserState {
  final File? profilePhotoFile;
  final UserModel userModel;

  UserAddSuccess({required this.profilePhotoFile, required this.userModel});

  @override
  List<Object?> get props => [profilePhotoFile, userModel];
}

class UserEditSuccess extends UserState {
  final File? profilePhotoFile;
  final UserModel userModel;

  UserEditSuccess({required this.profilePhotoFile, required this.userModel});

  @override
  List<Object?> get props => [profilePhotoFile, userModel];
}

class UserEditProfilePhotoLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserEditSubmitting extends UserState {

  final File? profilePhotoFile;
  final UserModel userModel;

  UserEditSubmitting({required this.profilePhotoFile, required this.userModel});

  @override
  List<Object?> get props => [profilePhotoFile];
}


class UserEditError extends UserState {

  final String errorMessage;

  UserEditError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}