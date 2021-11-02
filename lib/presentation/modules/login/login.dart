import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/login/forgot_password.dart';
import 'package:papers_for_peers/presentation/modules/login/utilities.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  bool _isLoading = false;
  String _loadingText = "";
  bool _isSignIn = true;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
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


  void signIn() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadingText = "Signing In";
      });
    }
    ApiResponse signInResponse = await _firebaseAuthService.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
        _loadingText = "";
      });
    }
    if (signInResponse.isError) {
      showAlertDialog(context: context, text: signInResponse.errorMessage);
    } else {
      print("SIGN IN DONE IN LOGIN");
    }
  }

  void signUp() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadingText = "Signing Up";
      });
    }
    ApiResponse signUpResponse = await _firebaseAuthService.signUpWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
        _loadingText = "";
      });
    }
    if (signUpResponse.isError) {
      showAlertDialog(context: context, text: signUpResponse.errorMessage);
    } else {
      print("SIGNED UP IN LOGIN");
    }
  }

  void continueWithGoogle() async {
    if (mounted) {
      setState(() { _isLoading = true; _loadingText = "Please wait..."; });
    }
    ApiResponse googleAuthResponse = await _firebaseAuthService.authenticateWithGoogle();
    if (mounted) {
      setState(() { _isLoading = false; });
    }
    if (googleAuthResponse.isError) {
      showAlertDialog(context: context, text: googleAuthResponse.errorMessage);
    } else {
      print("GOOGLE AUTH DONE IN LOGIN");
    }
  }

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
          body: _isLoading ? LoadingScreen(loadingText: _loadingText,) : Form(
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
                      controller: _emailController,
                      validator: (String val) => val.isValidEmail() ? null : "Please enter valid email",
                    ),
                    SizedBox(height: 20,),
                    getCustomPasswordField(
                      controller: _passwordController,
                      inputBoxText: 'Password',
                      obscureText: _isPasswordObscure,
                      onTapObscure: () { setState(() { _isPasswordObscure = !_isPasswordObscure; }); },
                      validator: (String val) => val.isEmpty ? "Enter Password" : null,
                    ),
                    _isSignIn ? Container() : SizedBox(height: 20,),
                    _isSignIn
                      ? SizedBox(height: 5,)
                      : getCustomPasswordField(
                        controller: _confirmPasswordController,
                        inputBoxText: 'Confirm Password',
                        obscureText: _isConfirmPasswordObscure,
                        onTapObscure: () { setState(() { _isConfirmPasswordObscure = !_isConfirmPasswordObscure; }); },
                        validator: (String val) => _passwordController.text == val ? null : "Passwords do not match",
                    ),
                    _isSignIn ?  Row(
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
                    _isSignIn ? Container():SizedBox(height: 40,) ,
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: getCustomButton(
                        buttonText: _isSignIn? "Sign In" : 'Sign Up',
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_isSignIn) {
                              signIn();
                            } else {
                              signUp();
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 35,),
                    getOrDivider(),
                    SizedBox(height: 30,),
                    TextButton(
                      onPressed: () {
                        continueWithGoogle();
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
                              text: _isSignIn ? "New Member? " : "Already a Member? ",
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {
                              setState(() { _isSignIn = !_isSignIn; });
                            },
                            text: _isSignIn ? "Create Account" : "Sign In" ,
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


