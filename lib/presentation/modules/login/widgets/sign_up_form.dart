import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/sign_up/sign_up_cubit.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    SignUpState signUpState = context.watch<SignUpCubit>().state;

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.signUpStatus.isError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
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
                Utils.getCustomTextField(
                  labelText: 'Email Address',
                  onChanged: (val) {
                    context.read<SignUpCubit>().emailChanged(val);
                  },
                  validator: (String? val) => context.read<SignUpCubit>().isEmailValid(val!) ? null : "Please enter valid email",
                ),
                SizedBox(height: 20,),
                Utils.getCustomPasswordField(
                  inputBoxText: 'Password',
                  onChanged: (val) {
                    context.read<SignUpCubit>().passwordChanged(val);
                  },
                  obscureText: signUpState.isPasswordObscure,
                  onTapObscure: () { context.read<SignUpCubit>().togglePasswordObscure(); },
                  validator: (String? val) => context.read<SignUpCubit>().isPasswordValid(val!) ? null : "Enter Password",
                ),
                SizedBox(height: 20,),
                Utils.getCustomPasswordField(
                  inputBoxText: 'Confirm Password',
                  onChanged: (val) {
                    context.read<SignUpCubit>().confirmPasswordChanged(val);
                  },
                  obscureText: signUpState.isConfirmPasswordObscure,
                  onTapObscure: () { context.read<SignUpCubit>().toggleConfirmPasswordObscure(); },
                  validator: (String? val) => context.read<SignUpCubit>().isConfirmPasswordValid(val!) ? null : "Passwords do not match",
                ),
                SizedBox(height: 20,),

                SizedBox(
                  width: 350,
                  height: 50,
                  child: signUpState.signUpStatus.isLoading
                      ? Center(child: CircularProgressIndicator.adaptive())
                      : Utils.getCustomButton(
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
