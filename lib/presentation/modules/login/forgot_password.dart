import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/login/utilities.dart';
import 'package:provider/provider.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool isResetPasswordLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

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
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                children: [
                  Image.asset(
                    DefaultAssets.lockImagePath,
                    height: 60,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    'We just need your registered email address send you password reset email',
                    style: CustomTextStyle.bodyTextStyle.copyWith(fontSize: 18),
                    // style: TextStyle(fontSize: 15,),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Form(
                    key: _formKey,
                    child: getCustomTextField(
                      labelText: 'Email Address',
                      controller: emailController,
                      validator: (String? val) => val!.isValidEmail() ? null : "Please enter valid email",
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  isResetPasswordLoading ? Center(
                    child: CircularProgressIndicator.adaptive(),
                  ) : getCustomButton(
                      buttonText: 'Reset Password',
                      width: 250,
                      verticalPadding: 14,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (mounted) setState(() { isResetPasswordLoading = true; });
                          bool isSuccess = await context.read<UserCubit>().sendPasswordResetEmail(emailController.text);
                          if (mounted) setState(() { isResetPasswordLoading = false; });

                          if (isSuccess) {
                            await showAlertDialog(context: context, text: "Password Reset Email Sent!");
                            Navigator.pop(context);
                          } else {
                            await showAlertDialog(context: context, text: "There was some error while sending password reset email");
                          }
                        }
                      }
                  ),
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
