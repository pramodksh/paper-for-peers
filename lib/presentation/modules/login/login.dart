import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/logic/cubits/sign_up/sign_up_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/login/forgot_password.dart';
import 'package:papers_for_peers/presentation/modules/login/utilities.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _isLoading = false;
  String _loadingText = "";
  bool _isSignIn = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget getOrDivider() {
    return Row(
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
  }

  void signIn() async {
    // if (mounted) {
    //   setState(() {
    //     _isLoading = true;
    //     _loadingText = "Signing In";
    //   });
    // }
    // ApiResponse signInResponse = await _firebaseAuthService.signInWithEmailAndPassword(
    //   email: _emailController.text,
    //   password: _passwordController.text,
    // );
    // if (mounted) {
    //   setState(() {
    //     _isLoading = false;
    //     _loadingText = "";
    //   });
    // }
    // if (signInResponse.isError) {
    //   showAlertDialog(context: context, text: signInResponse.errorMessage);
    // } else {
    //   print("SIGN IN DONE IN LOGIN");
    // }
  }

  void signUp() async {



    // if (mounted) {
    //   setState(() {
    //     _isLoading = true;
    //     _loadingText = "Signing Up";
    //   });
    // }
    // ApiResponse signUpResponse = await _firebaseAuthService.signUpWithEmailAndPassword(
    //   email: _emailController.text,
    //   password: _passwordController.text,
    // );
    // if (mounted) {
    //   setState(() {
    //     _isLoading = false;
    //     _loadingText = "";
    //   });
    // }
    // if (signUpResponse.isError) {
    //   showAlertDialog(context: context, text: signUpResponse.errorMessage);
    // } else {
    //   print("SIGNED UP IN LOGIN");
    // }
  }

  void continueWithGoogle() async {
    // if (mounted) {
    //   setState(() { _isLoading = true; _loadingText = "Please wait..."; });
    // }
    // ApiResponse googleAuthResponse = await _firebaseAuthService.authenticateWithGoogle();
    // if (mounted) {
    //   setState(() { _isLoading = false; });
    // }
    // if (googleAuthResponse.isError) {
    //   showAlertDialog(context: context, text: googleAuthResponse.errorMessage);
    // } else {
    //   print("GOOGLE AUTH DONE IN LOGIN");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(authRepository: context.read<AuthRepository>()),
      child: Builder(
        builder: (context) {

          SignUpState signUpState = context.watch<SignUpCubit>().state;

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
                              onChanged: (val) {
                                context.read<SignUpCubit>().emailChanged(val);
                              },
                              validator: (String? val) => context.read<SignUpCubit>().isEmailValid(val!) ? null : "Please enter valid email",
                            ),
                            SizedBox(height: 20,),
                            getCustomPasswordField(
                              inputBoxText: 'Password',
                              onChanged: (val) {
                                context.read<SignUpCubit>().passwordChanged(val);
                              },
                              obscureText: signUpState.isPasswordObscure,
                              onTapObscure: () { context.read<SignUpCubit>().togglePasswordObscure(); },
                              validator: (String? val) => context.read<SignUpCubit>().isPasswordValid(val!) ? null : "Enter Password",
                            ),
                            _isSignIn ? Container() : SizedBox(height: 20,),
                            _isSignIn
                              ? SizedBox(height: 5,)
                              : getCustomPasswordField(
                                inputBoxText: 'Confirm Password',
                                onChanged: (val) {
                                  context.read<SignUpCubit>().confirmPasswordChanged(val);
                                },
                                obscureText: signUpState.isConfirmPasswordObscure,
                                onTapObscure: () { context.read<SignUpCubit>().toggleConfirmPasswordObscure(); },
                                validator: (String? val) => context.read<SignUpCubit>().isConfirmPasswordValid(val!) ? null : "Passwords do not match",
                            ),
                            _isSignIn ? Row(
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
                              child: signUpState.signUpStatus == SignUpStatus.loading
                                ? Center(child: CircularProgressIndicator.adaptive())
                                : getCustomButton(
                                    buttonText: _isSignIn? "Sign In" : 'Sign Up',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_isSignIn) {
                                          // todo sign in
                                        } else {
                                          context.read<SignUpCubit>().signUpWithEmailAndPassword();
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
      ),
    );
  }
}


