import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart' as googleAuth;
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';

abstract class BaseAuthRepository {
  Stream<UserModel?> get user;
  UserModel? getCustomUserFromFirebaseUser(auth.User? user);
  Future<ApiResponse> signUpWithEmailAndPassword({required String email, required String password});
  Future<ApiResponse> signInWithEmailAndPassword({required String email, required String password});
  Future<ApiResponse> authenticateWithGoogle();
  Future<void> logoutUser();
}

class AuthRepository extends BaseAuthRepository {

  final auth.FirebaseAuth _firebaseAuth;
  final googleAuth.GoogleSignIn _googleSignIn;

  AuthRepository({auth.FirebaseAuth? firebaseAuth, googleAuth.GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance, _googleSignIn = googleAuth.GoogleSignIn();

  @override
  Future<ApiResponse> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("EMAIL PASSWORD SIGN UP DONE | ${userCredential.user.toString()}");
      return ApiResponse<UserModel>.success(data: UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        photoUrl: userCredential.user!.photoURL,
        displayName: userCredential.user!.displayName,
        fcmTokenList: []
      ));
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ApiResponse.error(errorMessage: "The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        return ApiResponse.error(errorMessage: "The account already exists for that email");
      } else {
        return ApiResponse.error(errorMessage: "Error signing in with email and password");
      }
    } catch (e) {
      return ApiResponse.error(errorMessage: "Error signing in with email and password");
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
      return ApiResponse<UserModel>.success(data: UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        photoUrl: userCredential.user!.photoURL,
        displayName: userCredential.user!.displayName,
        fcmTokenList: [],
      ));
    } on auth.FirebaseAuthException catch (e) {
      print("SIGN In ERROR: $e");
      if (e.code == 'user-not-found') {
        return ApiResponse.error(errorMessage: "No user found for that email");
      } else if (e.code == 'wrong-password') {
        return ApiResponse.error(errorMessage: "Wrong password provided for that user");
      } else {
        return ApiResponse.error(errorMessage: "Error while signing in");
      }
    }
  }

  @override
  Future<ApiResponse> authenticateWithGoogle() async {
    try {
      final googleAuth.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth.GoogleSignInAuthentication googleSignInAuth = await googleUser!.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );
      auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return ApiResponse<UserModel>.success(data: UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: userCredential.user!.displayName,
        photoUrl: userCredential.user!.photoURL,
        fcmTokenList: [],
      ));
    } catch (e) {
      print("GOOGLE AUTH ERROR: $e");
      return ApiResponse.error(errorMessage: "There was some error while authenticating with Google");
    }
  }

  @override
  UserModel? getCustomUserFromFirebaseUser(auth.User? user) {
    return user != null ? UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      fcmTokenList: [],
    ) : null;
  }

  @override
  Stream<UserModel?> get user => _firebaseAuth.userChanges().map(getCustomUserFromFirebaseUser);

  @override
  Future<void> logoutUser() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    print("USER LOGGED OUT");
  }

  bool get isCurrentUserEmailVerified => _firebaseAuth.currentUser!.emailVerified;

  Future<bool> sendVerificationEmail() async {
    auth.User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendForgotEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> reloadCurrentUser() async {
    await _firebaseAuth.currentUser!.reload();
  }

  auth.User get currentUser => _firebaseAuth.currentUser!;

}