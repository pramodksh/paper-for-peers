import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/models/api_response.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/modules/login/forgot_password.dart';
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

  bool _isLoading = false;
  String _loadingText = "";
  bool _isSignIn = true;
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


  void signIn() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadingText = "Signing In";
      });
    }
    ApiResponse signInResponse = await _firebaseAuthService.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
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
      email: emailController.text,
      password: passwordController.text,
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
      UserModel user = signUpResponse.data;
      bool isUserExists = await _firebaseFireStoreService.isUserExists(userId: user.uid);
      print("IS EXISTS: ${isUserExists}");
      if (!isUserExists && user.isEmailPasswordAuthDataAvailable()) {
        print("ADDING USER");
        if (mounted) {
          setState(() {
            _isLoading = true;
            _loadingText = "Please wait... (adding to database)";
          });
        }
        ApiResponse addUserResponse = await _firebaseFireStoreService.addUser(user: user);
        if (mounted) {
          setState(() {
            _isLoading = false;
            _loadingText = "";
          });
        }
        if (addUserResponse.isError) {
          showAlertDialog(context: context, text: addUserResponse.errorMessage);
        } else {
          await _firebaseAuthService.logoutUser();
          confirmPasswordController.clear();

          // todo try to show a dialog rather than toast
          Fluttertoast.showToast(
              msg: "Signed up successfully.\nPlease sign in to continue",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: CustomColors.bottomNavBarColor,
              textColor: Colors.white,
              fontSize: 18.0
          );

          if (mounted) {
            setState(() {
              _isSignIn = true;
              _isLoading = false;
              _loadingText = "";
            });
          }
          print("USER ADDED");
        }
      } else {
        print("USER EXISTS");
      }
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
      UserModel user = googleAuthResponse.data;
      bool isUserExists = await _firebaseFireStoreService.isUserExists(userId: user.uid);
      if (!isUserExists && user.isGoogleAuthDataAvailable()) {
        ApiResponse addUserResponse = await _firebaseFireStoreService.addUser(user: user);
        if (addUserResponse.isError) {
          showAlertDialog(context: context, text: addUserResponse.errorMessage);
        } else {
          await _firebaseAuthService.logoutUser(isGoogleLogout: false);
          await _firebaseAuthService.authenticateWithGoogle();
          print("USER ADDED && User logged out and logged in");
        }
      } else {
        print("USER EXISTS");
      }
    }
  }

  Widget _buildLoginAfterSignUpDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: CustomColors.reportDialogBackgroundColor,
      child: Container(
        // height: 400,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Text("Successfully Registered", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xff373F41), fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text("Please login to continue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black26),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.lightModeBottomNavBarColor)
                    ),
                    child: Text("Okay", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),),
                  ),
                ],
              ),
            ]
        ),
      ),
    );
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
                    _isSignIn ? Container() : SizedBox(height: 20,),
                    _isSignIn
                      ? SizedBox(height: 5,)
                      : getCustomPasswordField(
                        controller: confirmPasswordController,
                        inputBoxText: 'Confirm Password',
                        obscureText: _isConfirmPasswordObscure,
                        onTapObscure: () { setState(() { _isConfirmPasswordObscure = !_isConfirmPasswordObscure; }); },
                        validator: (String val) => passwordController.text == val ? null : "Passwords do not match",
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


