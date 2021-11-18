import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/login/login.dart';
import 'package:papers_for_peers/presentation/modules/login/send_verification_email.dart';
import 'package:papers_for_peers/presentation/modules/login/utilities.dart';
import 'package:provider/provider.dart';

import 'data/models/user_model/user_model.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {

    AuthRepository _authRepository = context.select((AuthRepository repo) => repo);
    // _authRepository.logoutUser();// todo delete
    return StreamBuilder(
      stream: _authRepository.user,
      builder: (context, snapshot) {
        UserModel? user = snapshot.data as UserModel?;
        print("CURRENT USER: $user | ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.active) {
          if (user == null) {
            return Login();
          } else {
            print("USER ID: ${user.uid}");
            print("USER EMAIL VERIFIED? : ${_authRepository.isCurrentUserEmailVerified}");
            if (!_authRepository.isCurrentUserEmailVerified) {
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
