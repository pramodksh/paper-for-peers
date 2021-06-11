import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/login/utilities.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(DefaultAssets.appBackgroundPath),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
              children: [
                Image.asset(
                  DefaultAssets.lockImagePath,
                  height: 60,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 70,
                ),
                Text(
                  'We just need your registered email address send you password reset email',
                  style: CustomTextStyle.bodyTextStyle.copyWith(fontSize: 18),
                  // style: TextStyle(fontSize: 15,),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 70,
                ),
                getCustomTextField(labelText: 'Email Address'),
                SizedBox(
                  height: 70,
                ),
                getCustomButton(
                    buttonText: 'Reset Password',
                    width: 250,
                    verticalPadding: 14,
                    textColor: Colors.white,
                    onPressed: () {
                      print("FORGOT PASSWORD");
                      Navigator.pop(context);
                    }
                ),
              ],
              ),
            ),
            ),
        ),
      ],
    );
  }
}
