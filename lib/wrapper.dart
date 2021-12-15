import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_remote_config/firebase_remote_config_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/shared_preference/shared_preference_repository.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/login/login.dart';
import 'package:papers_for_peers/presentation/modules/login/login_widgets/user_course.dart';
import 'package:papers_for_peers/presentation/modules/login/send_verification_email.dart';
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
          return LoadingScreen(loadingText: "Loading .",);
        } else {
          bool isUserExists = isUserExistSnapshot.data as bool;

          if (!isUserExists) {
            _authRepository.reloadCurrentUser();
            return LoadingScreen(loadingText: "Loading ..",);
          } else {
            return FutureBuilder(
              future: _firestoreRepository.getUserByUserId(userId: userModel.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                  return LoadingScreen(loadingText: "Loading ...",);
                } else {
                  UserModel userFromDatabase = snapshot.data as UserModel;
                  if (userFromDatabase.course == null || userFromDatabase.semester == null) {
                    return UserCourse(userModel: userFromDatabase,);
                  } else {
                    return FutureBuilder(
                      future: _sharedPreferenceRepository.getIsShowIntroScreen(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingScreen(loadingText: "Loading ....",);
                        } else {
                          bool isShowIntroScreen = snapshot.data as bool;
                          context.read<UserCubit>().setUser(userFromDatabase);
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


class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      FirebaseRemoteConfigRepository _firebaseRemoteConfigRepository = context.read<FirebaseRemoteConfigRepository>();
      AppConstants.reportReasons = await _firebaseRemoteConfigRepository.getReportsAndWeights();
    });
    super.initState();
  }

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
