import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<ApiResponse> signUpWithEmailAndPassword({required String email, required String password});
}

class AuthRepository extends BaseAuthRepository {

  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<ApiResponse> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("EMAIL PASSWORD SIGN UP DONE | ${userCredential.user.toString()}");
      return ApiResponse<UserModel>(isError: false, data: UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        photoUrl: userCredential.user!.photoURL,
        displayName: userCredential.user!.displayName,
      ));
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ApiResponse(isError: true, errorMessage: "The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        return ApiResponse(isError: true, errorMessage: "The account already exists for that email");
      } else {
        return ApiResponse(isError: true, errorMessage: "Error signing in with email and password");
      }
    } catch (e) {
      return ApiResponse(isError: true, errorMessage: "Error signing in with email and password");
    }
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

}