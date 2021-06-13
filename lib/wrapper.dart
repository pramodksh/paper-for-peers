import 'package:flutter/material.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';
import 'package:papers_for_peers/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/modules/login/user_course.dart';
import 'package:papers_for_peers/modules/login/user_details.dart';
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
            print("USER ID: ${user.uid}");

            // todo check stored data in cache : course, semester and pass in [MainDashboard]

            return FutureBuilder(
              future: FirebaseFireStoreService().getUserByUserId(userId: user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen(loadingText: "Fetching your details",);
                } else {
                  UserModel authenticatedUser = snapshot.data;
                  if (authenticatedUser.displayName == null || authenticatedUser.photoUrl == null) {
                    return UserDetails();
                  } else if (authenticatedUser.course == null || authenticatedUser.semester == null) {
                    return UserCourse(user: authenticatedUser,);
                  } else {
                    return MainDashboard();
                  }
                }
              },
            );
          }
        } else {
          return LoadingScreen(loadingText: "Please wait...",);
        }
      },
    );
  }
}
