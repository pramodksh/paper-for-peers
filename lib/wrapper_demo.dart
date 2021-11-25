import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/login/login.dart';
import 'package:papers_for_peers/presentation/modules/login/user_course.dart';
import 'package:papers_for_peers/presentation/modules/login_v2/login_demo.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class MainDashboardWrapper extends StatelessWidget {

  final UserModel userModel;

  MainDashboardWrapper({required this.userModel});

  @override
  Widget build(BuildContext context) {
    FirestoreRepository _firestoreRepository = context.select((FirestoreRepository repo) => repo);
    AuthRepository _authRepository = context.select((AuthRepository repo) => repo);

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
                  print("LOADING>> (GET USER BY ID)");
                  return LoadingScreen(loadingText: "GETTING USER BY ID",);
                } else {
                  UserModel userFromDatabase = snapshot.data as UserModel;
                  print("USER FROM DATABASE LOADED: ${userFromDatabase.course} || ${userFromDatabase.semester}");
                  if (userFromDatabase.course == null || userFromDatabase.semester == null) {
                    return UserCourse(userModel: userFromDatabase,);
                  } else {
                    return MainDashboard();
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


class WrapperDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthRepository _authRepository = context.select((AuthRepository repo) => repo);
    FirestoreRepository _firestoreRepository = context.select((FirestoreRepository repo) => repo);

    // todo remove
    // _authRepository.logoutUser();

    return StreamBuilder(
      stream: _authRepository.user,
      builder: (context, snapshot) {
        UserModel? userFromStream = snapshot.data as UserModel?;
        if (userFromStream == null) {
          print("WRAPPER DEMO: USER NULL");
          return LoginDemo();
        } else {
          print("WRAPPER DEMO: USER NOT NULL: $userFromStream");

          return MainDashboardWrapper(userModel: userFromStream,);

          // return FutureBuilder(
          //   future: _firestoreRepository.isUserExists(userId: userFromStream.uid),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       print("LOADING: is user exists");
          //       return LoadingScreen(loadingText: "CHECKING IF USER EXISTS",);
          //     } else {
          //       bool isUserExists = snapshot.data as bool;
          //       print("WRAPPER DEMO: USER EXISTS: $isUserExists");
          //
          //       context.read<UserCubit>().setUser(userFromStream);
          //
          //       if (isUserExists) {
          //         return MainDashboardWrapper();
          //       } else {
          //
          //
          //
          //         // return FutureBuilder(
          //         //   future: _firestoreRepository.addUser(user: userFromStream),
          //         //   builder: (context, snapshot) {
          //         //     if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          //         //       print("LOADING>> (ADD USER)");
          //         //       return LoadingScreen(loadingText: "ADDING USER",);
          //         //     } else {
          //         //       ApiResponse addResponse = snapshot.data as ApiResponse;
          //         //       if (addResponse.isError) {
          //         //         print("ADD ERROR: ${addResponse.errorMessage}");
          //         //         Utils.showAlertDialog(context: context, text: addResponse.errorMessage);
          //         //         return Login();
          //         //       } else {
          //         //         context.read<UserCubit>().setUser(userFromStream);
          //         //
          //         //
          //         //       }
          //         //     }
          //         //   },
          //         // );
          //       }
          //     }
          //
          //   }
          // );
        }
      },
    );
  }
}
