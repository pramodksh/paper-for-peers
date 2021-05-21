import 'package:flutter/gestures.dart';
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

  Widget getSizedBox() => SizedBox(
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    print("LOGIN? ${_isLogIn}");

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
                  getSizedBox(),
                  customTextField(inputBoxText: 'Email Address'),
                  getSizedBox(),
                  customTextField(inputBoxText: 'Password', obscureText: true),
                  _isLogIn ? Container() : getSizedBox(),
                  _isLogIn
                    ? Container()
                    : customTextField(inputBoxText: 'Confirm Password', obscureText: true
                  ),
                  _isLogIn ?  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ));

                          // Navigator.of(context).push(
                          //   PageRouteBuilder(
                          //     transitionDuration: Duration(seconds: 5),
                          //     pageBuilder: (context, animation, secondaryAnimation) => ForgotPassword(),
                          //   )
                          // );

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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  RichText(
                    text: TextSpan(
                      // text: _isLogIn ? "Already a Member" : "New Member",
                      style: TextStyle(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: _isLogIn ? "Already a Member? " : "New Member? ",
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {
                            setState(() { _isLogIn = !_isLogIn; });
                          },
                          text: _isLogIn ? "Sign In" : "Create Account",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  )

                  // TextButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _isLogIn = !_isLogIn;
                  //     });
                  //   },
                  //   child: Text(
                  //     _isLogIn
                  //         ? 'Already a Member? Sign In'
                  //         : "New Member ? Create Account",
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


