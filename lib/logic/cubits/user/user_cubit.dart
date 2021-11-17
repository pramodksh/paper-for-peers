import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {

  final FirestoreRepository _firestoreRepository;

  UserCubit({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository, super(UserInitial());

  void setUser(UserModel userModel) {
    emit(UserLoaded(userModel: userModel,));
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

  Future<bool> isUserExists(UserModel user) async => await _firestoreRepository.isUserExists(userId: user.uid);

  Future<UserModel> getUserById({required String userId}) async => await _firestoreRepository.getUserByUserId(userId: userId);
}
