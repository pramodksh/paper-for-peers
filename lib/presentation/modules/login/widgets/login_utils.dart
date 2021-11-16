import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

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

  static Widget getContinueWithGoogleButton() {
    return TextButton(
      onPressed: () {
        // todo continue with google
        // continueWithGoogle();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            DefaultAssets.googleIconPath,
            height: 30,
          ),
          SizedBox(width: 15,),
          Text(
            'Continue with Google',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

}