import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/login/login.dart';
import 'package:papers_for_peers/presentation/modules/login/user_course.dart';
import 'package:papers_for_peers/presentation/modules/login/user_details.dart';
import 'package:provider/provider.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

Widget getCustomPasswordField({
  required String? Function(String?)? validator,
  TextEditingController? controller,
  String? inputBoxText,
  bool obscureText = true,
  VoidCallback? onTapObscure,
  Function(String)? onChanged,
}) {
  return TextFormField(
    onChanged: onChanged,
    controller: controller,
    validator: validator,
    style: TextStyle(fontSize: 16, color: Colors.white),
    obscureText: obscureText,
    decoration: InputDecoration(
      suffixIcon: IconButton(
        splashRadius: 20,
        onPressed: onTapObscure,
        icon: obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        color: Colors.white,
      ),
      isDense: true,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(15.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(15.0),
      ),
      labelText: inputBoxText,
      errorStyle: TextStyle(color: Colors.white),
    ),
  );
}


Widget getCustomTextField({
  required String? Function(String?)? validator,
  TextEditingController? controller,
  String? labelText,
  String? hintText,
  bool obscureText = false,
  Function(String)? onChanged,
}) {
  return TextFormField(
    onChanged: onChanged,
    controller: controller,
    validator: validator,
    style: TextStyle(fontSize: 16, color: Colors.white),
    obscureText: obscureText,
    decoration: InputDecoration(
      isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: labelText,
        hintText: hintText,
        errorStyle: TextStyle(color: Colors.white),
    ),
  );
}

Widget getCustomButton({required String buttonText, required Function() onPressed, double? width, double verticalPadding = 5 ,Color textColor = Colors.white}){
  Widget button = ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: verticalPadding)),
      backgroundColor: MaterialStateProperty.all(Colors.white38),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
              side: BorderSide(
                  color: Colors.transparent,
                  width: 200
              )
          )
      ),
    ),
    child: Text(
      buttonText,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: textColor),
    ),
  );

  if (width == null) {
    return button;
  } else {
    return SizedBox(width: width, child: button,);
  }

}

Widget getAppropriateWidget({required UserModel user, required BuildContext context}) {

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
          return UserCourse();
        } else {
          return MainDashboard();
        }
      }
    },
  );
}


Widget addUserIfNotExistsAndGetWidget({required UserModel user, required BuildContext context}) {

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


void showToast({required String label}) {
  Fluttertoast.showToast(
      msg: label,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: CustomColors.bottomNavBarColor,
      textColor: Colors.white,
      fontSize: 18.0
  );
}