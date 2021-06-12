import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:papers_for_peers/models/api_response.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';

class FirebaseAuthService {

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    ) : null;
  }

  Stream<UserModel> get user {
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<ApiResponse> signUpWithEmailAndPassword({@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      print("EMAIL PASSWORD SIGN IN DONE | ${userCredential.user.email}");
      return ApiResponse(isError: false);
    } on FirebaseAuthException catch (e) {
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
  
  Future<ApiResponse> signInWithEmailAndPassword({@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
      print("EMAIL PASSWORD SIGN UP DONE | ${userCredential.user.email}");
      return ApiResponse(isError: false);
    } on FirebaseAuthException catch (e) {
      print("SIGN UP ERROR: $e");
      if (e.code == 'user-not-found') {
        return ApiResponse(isError: true, errorMessage: "No user found for that email");
      } else if (e.code == 'wrong-password') {
        return ApiResponse(isError: true, errorMessage: "Wrong password provided for that user");
      } else {
        return ApiResponse(isError: true, errorMessage: "Error while signing in");
      }
    }
  }

  // todo send verification email

  Future<UserCredential> authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logoutUser() async {
    await auth.signOut();
    await _googleSignIn.signOut();
    print("USER LOGGED OUT");
  }

}