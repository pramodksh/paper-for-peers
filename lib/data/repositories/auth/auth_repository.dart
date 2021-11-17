import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart' as googleAuth;
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<ApiResponse> signUpWithEmailAndPassword({required String email, required String password});
  Future<ApiResponse> signInWithEmailAndPassword({required String email, required String password});
  Future<ApiResponse> authenticateWithGoogle();
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
  Future<ApiResponse> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("EMAIL PASSWORD SIGN IN DONE | ${userCredential.user!.email}");
      return ApiResponse<UserModel>(isError: false, data: UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        photoUrl: userCredential.user!.photoURL,
        displayName: userCredential.user!.displayName,
      ));
    } on auth.FirebaseAuthException catch (e) {
      print("SIGN In ERROR: $e");
      if (e.code == 'user-not-found') {
        return ApiResponse(isError: true, errorMessage: "No user found for that email");
      } else if (e.code == 'wrong-password') {
        return ApiResponse(isError: true, errorMessage: "Wrong password provided for that user");
      } else {
        return ApiResponse(isError: true, errorMessage: "Error while signing in");
      }
    }
  }

  @override
  Future<ApiResponse> authenticateWithGoogle() async {
    try {
      final googleAuth.GoogleSignInAccount? googleUser = await googleAuth.GoogleSignIn().signIn();
      final googleAuth.GoogleSignInAuthentication googleSignInAuth = await googleUser!.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );
      auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return ApiResponse<UserModel>(isError: false, data: UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: userCredential.user!.displayName,
        photoUrl: userCredential.user!.photoURL,
      ));
    } catch (e) {
      print("GOOGLE AUTH ERROR: $e");
      return ApiResponse(isError: true, errorMessage: "There was some error while authenticating with Google");
    }
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

}