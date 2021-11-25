import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/shared_preference/shared_preference_repository.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/login/send_verification_email.dart';
import 'package:papers_for_peers/presentation/modules/login/login_widgets/user_course.dart';
import 'package:papers_for_peers/presentation/modules/login/login.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class MainDashboardWrapper extends StatelessWidget {

  final UserModel userModel;
  MainDashboardWrapper({required this.userModel});

  @override
  Widget build(BuildContext context) {
    FirestoreRepository _firestoreRepository = context.select((FirestoreRepository repo) => repo);
    AuthRepository _authRepository = context.select((AuthRepository repo) => repo);
    SharedPreferenceRepository _sharedPreferenceRepository = context.select((SharedPreferenceRepository repo) => repo);

    // reload user of user does not exist in database
    // added because we have to wait until user is added to database
    return FutureBuilder(
      future:  _firestoreRepository.isUserExists(userId: userModel.uid),
      builder: (context, isUserExistSnapshot) {
        if (isUserExistSnapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen(loadingText: "MAIN DASHBOARD: IS USER EXISTS",);
        } else {
          bool isUserExists = isUserExistSnapshot.data as bool;

          if (!isUserExists) {
            _authRepository.reloadCurrentUser();
            return LoadingScreen(loadingText: "MAIN DASHBOARD RELOADING USER",);
          } else {
            return FutureBuilder(
              future: _firestoreRepository.getUserByUserId(userId: userModel.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen(loadingText: "GETTING USER BY ID",);
                } else {
                  UserModel userFromDatabase = snapshot.data as UserModel;
                  if (userFromDatabase.course == null || userFromDatabase.semester == null) {
                    return UserCourse(userModel: userFromDatabase,);
                  } else {
                    return FutureBuilder(
                      future: _sharedPreferenceRepository.getIsShowIntroScreen(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingScreen(loadingText: "LOADING SHARED PREFS",);
                        } else {
                          bool isShowIntroScreen = snapshot.data as bool;
                          return MainDashboard(isDisplayWelcomeScreen: isShowIntroScreen,);
                        }

                      }
                    );
                  }
                }
              },
            );
          }
        }
      }
    );
  }
}


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthRepository _authRepository = context.select((AuthRepository repo) => repo);

    return StreamBuilder(
      stream: _authRepository.user,
      builder: (context, snapshot) {
        UserModel? userFromStream = snapshot.data as UserModel?;
        if (userFromStream == null) {
          return LoginDemo();
        } else if (!_authRepository.currentUser.emailVerified){
          return SendVerificationEmail(user: userFromStream,);
        } else {
          return MainDashboardWrapper(userModel: userFromStream,);
        }
      },
    );
  }
}
