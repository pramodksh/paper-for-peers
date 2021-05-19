import 'package:papers_for_peers/module/login/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage(
            'assets\\images\\appBackground.png',
          ),
        )),
        child: Container(
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
                    height: 20,
                  ),
                  customTextField(
                      inputBoxText: 'Confirm Password', obscureText: true),
                  SizedBox(
                    height: 40,
                  ),
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
                                        width: 200
                                    )
                                )
                            ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
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
    );
  }
}
