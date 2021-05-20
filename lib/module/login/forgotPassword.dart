import 'package:flutter/material.dart';
import 'package:papers_for_peers/module/login/utils.dart';

class forgotPassword extends StatefulWidget {
  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets\\images\\appBackground.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
            body: Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.fromLTRB(50, 130, 50, 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets\\images\\lock-image.png',
                    height: 60,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    'We just need your registered email address send you password reset',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  customTextField(inputBoxText: 'Email Address'),
                  SizedBox(
                    height: 70,
                  ),
                  customButton(
                      buttonText: 'Reset Password',
                      width: 250,
                      verticalPadding: 14,
                      textColor: Colors.white,
                      onPressed: () {
                        print("FORGOT PASSWORD");
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }
}
