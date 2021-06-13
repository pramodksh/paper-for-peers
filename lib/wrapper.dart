import 'package:flutter/material.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';
import 'package:papers_for_peers/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';
import 'package:papers_for_peers/services/firebase_firestore/firebase_firestore_service.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuthService().user,
      builder: (context, snapshot) {
        UserModel user = snapshot.data;
        print("CURRENT USER: ${user} | ${snapshot.connectionState}");

        if (snapshot.connectionState == ConnectionState.active) {
          if (user == null) {
            return Login();
          } else {
            FirebaseFireStoreService().getUserByUserId(userId: user.uid);
            return MainDashboard();
          }
        } else {
          return LoadingScreen(loadingText: "Please wait...",);
        }
      },
    );
  }
}
