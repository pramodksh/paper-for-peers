import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/image_picker/image_picker_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {

  final FirestoreRepository _firestoreRepository;
  final FirebaseStorageRepository _firebaseStorageRepository;
  final ImagePickerRepository _imagePickerRepository;

  UserCubit({
    required FirestoreRepository firestoreRepository,
    required FirebaseStorageRepository firebaseStorageRepository,
    required ImagePickerRepository imagePickerRepository,
  }) : _firestoreRepository = firestoreRepository,
        _firebaseStorageRepository = firebaseStorageRepository,
        _imagePickerRepository = imagePickerRepository,
        super(UserInitial());

  Future<void> pickImage({required ImageSource imageSource, required String? userName}) async {
    emit(UserEditLoading());

    File? file = await _imagePickerRepository.getPickedImageAsFile(imageSource: imageSource);

    if (file == null) {
      emit(UserEditSuccess(profilePhotoFile: null, userName: userName));
    } else {
      emit(UserEditLoading());
      File? croppedFile = await _imagePickerRepository.getCroppedImage(imageFile: file);
      emit(UserEditSuccess(profilePhotoFile: croppedFile, userName: userName));
    }

  }

  void setUser(UserModel userModel) {
    emit(UserLoaded(userModel: userModel,));
  }

  void initiateUserEdit() {
    emit(UserEditSuccess(profilePhotoFile: null, userName: null));
  }

  void editUser({required File? profilePhotoFile, required String? userName,}) {
    emit(UserEditSuccess(profilePhotoFile: profilePhotoFile, userName: userName));
  }

  Future<ApiResponse> addUser(UserModel userModel) async {
    emit(UserLoading());
    ApiResponse addUserResponse = await _firestoreRepository.addUser(user: userModel,);

    if (addUserResponse.isError) {
      emit(UserError(errorMessage: addUserResponse.errorMessage!));
    } else {
      emit(UserLoaded(userModel: userModel));
    }

    return addUserResponse;
  }

  Future<ApiResponse> uploadProfilePhotoToStorage({
    required File file,
    required UserModel user,
  }) async => await _firebaseStorageRepository.uploadProfilePhoto(file: file, userId: user.uid);

  Future<bool> isUserExists(UserModel user) async => await _firestoreRepository.isUserExists(userId: user.uid);

  Future<UserModel> getUserById({required String userId}) async => await _firestoreRepository.getUserByUserId(userId: userId);
}
