import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/models/api_response.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';
import 'package:papers_for_peers/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/modules/login/user_course.dart';
import 'package:papers_for_peers/modules/login/user_details.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';
import 'package:papers_for_peers/services/firebase_firestore/firebase_firestore_service.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

Widget getCustomPasswordField({
  @required TextEditingController controller,
  @required Function validator,
  String inputBoxText,
  bool obscureText = true,
  VoidCallback onTapObscure,
}) {
  return TextFormField(
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
  @required TextEditingController controller,
  @required Function validator,
  String labelText,
  String hintText,
  bool obscureText = false,
  Function onChanged,
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

Widget getCustomButton({@required String buttonText, @required Function onPressed, double width, double verticalPadding = 5 ,Color textColor = Colors.white}){
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

Widget getAppropriateWidget({@required UserModel user, @required BuildContext context}) {

  FirebaseFireStoreService _firebaseFireStoreService = FirebaseFireStoreService();

  return FutureBuilder(
    future: _firebaseFireStoreService.getUserByUserId(userId: user.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
        return LoadingScreen(loadingText: "Fetching your details",);
      } else {
        UserModel authenticatedUser = snapshot.data;
        if (authenticatedUser.displayName == null || authenticatedUser.photoUrl == null) {
          return UserDetails(user: authenticatedUser,);
        } else if (authenticatedUser.course == null || authenticatedUser.semester == null) {
          return UserCourse(user: authenticatedUser,);
        } else {
          return MainDashboard();
        }
      }
    },
  );
}


Widget addUserIfNotExistsAndGetWidget({@required UserModel user, @required BuildContext context}) {

  FirebaseFireStoreService _firebaseFireStoreService = FirebaseFireStoreService();

  return FutureBuilder(
    future: _firebaseFireStoreService.isUserExists(userId: user.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
        return LoadingScreen(loadingText: "Checking if user exists",);
      } else {
        bool isUserExists = snapshot.data;
        if (!isUserExists) {
          print("ADDING USER");

          return FutureBuilder(
            future: _firebaseFireStoreService.addUser(user: user),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
                return LoadingScreen(loadingText: "Adding user",);
              } else {
                ApiResponse addUserResponse = snapshot.data;
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


void showToast({@required String label}) {
  Fluttertoast.showToast(
      msg: label,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: CustomColors.bottomNavBarColor,
      textColor: Colors.white,
      fontSize: 18.0
  );
}