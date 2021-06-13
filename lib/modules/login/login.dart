import 'package:flutter/gestures.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/models/api_response.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/modules/login/forgot_password.dart';
import 'package:papers_for_peers/modules/login/user_details.dart';
import 'package:papers_for_peers/modules/login/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';
import 'package:papers_for_peers/services/firebase_firestore/firebase_firestore_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  FirebaseFireStoreService _firebaseFireStoreService = FirebaseFireStoreService();

  bool _isLogIn = true;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget getOrDivider() => Row(
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
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                      height: 50,
                    ),
                    SizedBox(height: 20,),
                    getCustomTextField(
                      labelText: 'Email Address',
                      controller: emailController,
                      validator: (String val) => val.isValidEmail() ? null : "Please enter valid email",
                    ),
                    SizedBox(height: 20,),
                    getCustomPasswordField(
                      controller: passwordController,
                      inputBoxText: 'Password',
                      obscureText: _isPasswordObscure,
                      onTapObscure: () { setState(() { _isPasswordObscure = !_isPasswordObscure; }); },
                      validator: (String val) => val.isEmpty ? "Enter Password" : null,
                    ),
                    _isLogIn ? Container() : SizedBox(height: 20,),
                    _isLogIn
                      ? SizedBox(height: 5,)
                      : getCustomPasswordField(
                        controller: confirmPasswordController,
                        inputBoxText: 'Confirm Password',
                        obscureText: _isConfirmPasswordObscure,
                        onTapObscure: () { setState(() { _isConfirmPasswordObscure = !_isConfirmPasswordObscure; }); },
                        validator: (String val) => passwordController.text == val ? null : "Passwords do not match",
                    ),
                    _isLogIn ?  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Forgot Password?', style: TextStyle(color: Colors.white, fontSize: 18),),
                          onPressed: (){
                            // todo implement forgot password
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ));
                          },
                        ),
                      ],
                    ) : Container() ,
                    SizedBox(height: 20,),
                    _isLogIn ? Container():SizedBox(height: 40,) ,
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: getCustomButton(
                        buttonText: _isLogIn? "Sign In" : 'Sign Up',
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (_isLogIn) {
                              // todo display alert if error
                              ApiResponse signInResponse = await _firebaseAuthService.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            } else {
                              // todo display alert if error
                              ApiResponse signUpResponse = await _firebaseAuthService.signUpWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              if (signUpResponse.isError) {
                                showAlertDialog(context: context, text: signUpResponse.errorMessage);
                              } else {
                                // todo save in database
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserDetails(),
                              ));
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 35,),
                    getOrDivider(),
                    SizedBox(height: 30,),
                    TextButton(
                      onPressed: () async {
                       ApiResponse googleAuthResponse = await _firebaseAuthService.authenticateWithGoogle();
                       if (googleAuthResponse.isError) {
                         showAlertDialog(context: context, text: googleAuthResponse.errorMessage);
                       } else {
                         UserModel user = googleAuthResponse.data;
                         bool isUserExists = await _firebaseFireStoreService.isUserExists(userId: user.uid);
                         if (!isUserExists && user.isAuthDataAvailable()) {
                           // todo save user in database
                           ApiResponse addUserResponse = await _firebaseFireStoreService.addUser(user: user);
                           if (addUserResponse.isError) {
                             showAlertDialog(context: context, text: addUserResponse.errorMessage);
                           } else {
                             print("USER ADDED");
                           }
                         } else {
                           print("USER EXISTS");
                         }
                       }
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
                    ),
                    SizedBox(height: 20,),
                    RichText(
                      text: TextSpan(
                        style: CustomTextStyle.bodyTextStyle.copyWith(fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                              text: _isLogIn ? "New Member? " : "Already a Member? ",
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {
                              setState(() { _isLogIn = !_isLogIn; });
                            },
                            text: _isLogIn ? "Create Account" : "Sign In" ,
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
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
      ],
    );
  }
}


