import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/module/login/forgotPassword.dart';
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
        Container(
          // TODO : Reduce the opacity of background

          child: Image.asset(
            DefaultAssets.appBackgroundPath,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
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
                    DefaultAssets.mainLogoPath,
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
                        child: Text('Forgot Password?',
                          style: TextStyle(
                            color: Colors.black38
                          ),
                        ),
                        onPressed: (){
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => forgotPassword(),
                          // ));

                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: Duration(seconds: 5),
                              pageBuilder: (context, animation, secondaryAnimation) => ForgotPassword(),
                            )
                          );

                        },
                      ),
                    ],
                  ):Container() ,
                  _isLogIn ? Container():SizedBox(height: 40,) ,
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: customButton(
                      buttonText: _isLogIn? "Sign In" : 'Sign Up',
                      onPressed: () {},
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
                          DefaultAssets.googleIconPath,
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


