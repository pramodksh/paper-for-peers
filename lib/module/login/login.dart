import 'package:papers_for_peers/module/login/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLogIn = true;

  Widget getOrDivider() => Row(
        children: <Widget>[
          Expanded(
            child: Container(height: 2.0, color: Colors.grey),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.0),
            child: Text("OR", style: TextStyle(color: Colors.black)),
          ),
          Expanded(
            child: Container(
              height: 2.0,
              color: Colors.grey,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    print("LOGIN? ${_isLogIn}");

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
          body: SingleChildScrollView(
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
                    _isLogIn ? 'Sign In' : 'Sign Up',
                    style: GoogleFonts.ptSans(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  customTextField(inputBoxText: 'Email Address'),
                  SizedBox(
                    height: 20,
                  ),
                  customTextField(inputBoxText: 'Password', obscureText: true),
                  SizedBox(
                    height: 10,
                  ),
                  _isLogIn
                      ? Container()
                      : customTextField(
                          inputBoxText: 'Confirm Password', obscureText: true),
                  _isLogIn ?  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Forgot Password',
                          style: TextStyle(
                            color: Colors.black38
                          ),
                        ),
                        onPressed: (){},
                      ),
                    ],
                  ):Container() ,
                  _isLogIn ? Container():SizedBox(height: 40,) ,
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black12),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    side: BorderSide(
                                        color: Colors.transparent,
                                        width: 200))),
                      ),
                      child: Text(
                        _isLogIn ? "Sign In" : 'Sign Up',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 35,),
                  getOrDivider(),
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
                          height: 50,
                        ),
                        Text(
                          'Continue from Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogIn = !_isLogIn;
                      });
                    },
                    child: Text(
                      _isLogIn
                          ? 'Already a Member? Sign In'
                          : "New Member ? Create Account",
                    ),
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
