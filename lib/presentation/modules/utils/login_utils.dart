import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/text_styles.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/login/login.dart';
import 'package:papers_for_peers/presentation/modules/login_v2/widgets_demo/user_course.dart';
import 'package:papers_for_peers/presentation/modules/login/user_details.dart';
import 'package:provider/provider.dart';

class LoginUtils {

  static Widget getOrDivider() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(height: 2.0, color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          child: Text("OR", style: CustomTextStyle.bodyTextStyle.copyWith(letterSpacing: 4),),
        ),
        Expanded(
          child: Container(
            height: 2.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  static Widget getAppropriateWidget({required UserModel user, required BuildContext context}) {

    print("GET APPROPRIATE WIDGET");
    return FutureBuilder(
      future: context.read<UserCubit>().getUserById(userId: user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
          return LoadingScreen(loadingText: "Fetching your details",);
        } else {

          UserModel authenticatedUser = snapshot.data as UserModel;

          context.read<UserCubit>().setUser(authenticatedUser);

          if (authenticatedUser.displayName == null || authenticatedUser.displayName!.isEmpty) {
            return UserDetails();
          } else if (authenticatedUser.course == null || authenticatedUser.semester == null) {
            return UserCourse(userModel: authenticatedUser,);
          } else {
            return MainDashboard();
          }
        }
      },
    );
  }


  static Widget addUserIfNotExistsAndGetWidget({required UserModel user, required BuildContext context}) {

    return FutureBuilder(
      future: context.read<UserCubit>().isUserExists(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
          return LoadingScreen(loadingText: "Checking if user exists",);
        } else {
          bool isUserExists = snapshot.data as bool;
          if (!isUserExists) {
            print("ADDING USER");

            return FutureBuilder(
              future: context.read<UserCubit>().addUser(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
                  return LoadingScreen(loadingText: "Adding user",);
                } else {
                  ApiResponse addUserResponse = snapshot.data as ApiResponse;
                  if (addUserResponse.isError) {
                    print("ADD USER ERR: ${addUserResponse.errorMessage}");
                    return Login();
                  } else {
                    return getAppropriateWidget(user: user, context: context);
                  }
                }
              },
            );
          } else {
            print("USER EXISTS");
            return getAppropriateWidget(user: user, context: context);
          }
        }
      },
    );
  }

}