import 'package:flutter/material.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/modules/login/send_verification_email.dart';
import 'package:papers_for_peers/modules/login/utilities.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseAuthService.user,
      builder: (context, snapshot) {
        UserModel user = snapshot.data;
        print("CURRENT USER: ${user} | ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.active) {
          if (user == null) {
            return Login();
          } else {
            print("USER ID: ${user.uid}");
            print("USER EMAIL VERIFIED? : ${_firebaseAuthService.isCurrentUserEmailVerified}");
            if (!_firebaseAuthService.isCurrentUserEmailVerified) {
              return SendVerificationEmail(user: user,);
            } else {
              return addUserIfNotExistsAndGetWidget(context: context, user: user);
            }
          }
        } else {
          return LoadingScreen(loadingText: "Please wait...",);
        }
      },
    );
  }
}
