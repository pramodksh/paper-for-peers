import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/sign_up/sign_up_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/login/utilities.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    SignUpState signUpState = context.watch<SignUpCubit>().state;

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.signUpStatus.isError) {
          showAlertDialog(context: context, text: state.errorMessage);
        }
      },
      child: Container(
          margin: EdgeInsets.fromLTRB(55, 70, 55, 30),
          width: MediaQuery.of(context).size.width,
          // color: Colors.red,
          child: Form(
            key: _formKey,
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
                SizedBox(height: 20,),
                getCustomPasswordField(
                  inputBoxText: 'Confirm Password',
                  onChanged: (val) {
                    context.read<SignUpCubit>().confirmPasswordChanged(val);
                  },
                  obscureText: signUpState.isConfirmPasswordObscure,
                  onTapObscure: () { context.read<SignUpCubit>().toggleConfirmPasswordObscure(); },
                  validator: (String? val) => context.read<SignUpCubit>().isConfirmPasswordValid(val!) ? null : "Passwords do not match",
                ),
                // _isSignIn ? Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     TextButton(
                //       child: Text('Forgot Password?', style: TextStyle(color: Colors.white, fontSize: 18),),
                //       onPressed: (){
                //         // todo implement forgot password
                //         Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) => ForgotPassword(),
                //         ));
                //       },
                //     ),
                //   ],
                // ) : Container() ,
                SizedBox(height: 20,),

                SizedBox(
                  width: 350,
                  height: 50,
                  child: signUpState.signUpStatus.isLoading
                      ? Center(child: CircularProgressIndicator.adaptive())
                      : getCustomButton(
                    buttonText: 'Sign Up',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignUpCubit>().signUpWithEmailAndPassword();
                      }
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
}
