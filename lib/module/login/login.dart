import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget getCustomButton({
    @required String label,
    @required Function onPressed,
    Color backGroundColor = Colors.red,
    double labelFontSize = 20,
    double width,
  }) {
    Widget button = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backGroundColor)),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: labelFontSize, color: Colors.white),
      ),
    );
    if (width == null) {
      return button;
    } else {
      return SizedBox(
        width: width,
        child: button,
      );
    }
  }

  Widget InputBox(String inputBoxText, bool obscureText) {
    return TextField(
      obscureText: obscureText,
      // textInputAction: ,
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: inputBoxText,
          labelStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black
            // height: 4
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets\\images\\appBackground.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(55, 70, 55, 30),
              width: MediaQuery.of(context).size.width,
              // color: Colors.red,
              child: Column(
                children: [
                  Image.asset(
                    'assets\\logo\\mainLogo.png',
                    height: 110,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.ptSans(
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputBox('Email Address', false),
                  SizedBox(
                    height: 20,
                  ),
                  InputBox('Password', true),
                  SizedBox(
                    height: 20,
                  ),
                  InputBox('Confirm Password', true),
                  // todo : Forgot Password Code Here

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TextButton(
                  //       onPressed: (){},
                  //         child: Text(
                  //       'Forgot Password?',
                  //     )),
                  //   ],
                  // ),

                  SizedBox(
                    height: 40,
                  ),
                  // TextButton(
                  //   child: Text(
                  //     'Sign Up',
                  //     style: TextStyle(
                  //         color: Colors.red, backgroundColor: Colors.blue),
                  //   ),
                  //   onPressed: () {},
                  //   style: ButtonStyle(
                  //       padding: MaterialStateProperty.all<EdgeInsets>(
                  //           EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                  //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //           RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(26.0),
                  //               side: BorderSide(color: Colors.yellow)))),
                  // ),
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                        //
                        // padding: MaterialStateProperty.all<EdgeInsets>(
                        //     EdgeInsets.symmetric(
                        //         vertical: 20,
                        //         horizontal:
                        //             MediaQuery.of(context).size.width * .32)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    side: BorderSide(
                                        color: Colors.transparent,
                                        width: 200))),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  // ElevatedButton()
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets\\logo\\google-icon.png',
                          height: 30,
                        ),
                        Divider(
                          height: 15,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Continue from Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
