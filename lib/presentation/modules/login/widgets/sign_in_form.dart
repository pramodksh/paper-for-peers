import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/sign_in/sign_in_cubit.dart';
import 'package:papers_for_peers/presentation/modules/login/forgot_password.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    SignInState signInState = context.watch<SignInCubit>().state;

    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.signInStatus.isError) {
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
                    context.read<SignInCubit>().emailChanged(val);
                  },
                  validator: (String? val) => context.read<SignInCubit>().isEmailValid(val!) ? null : "Please enter valid email",
                ),
                SizedBox(height: 20,),
                Utils.getCustomPasswordField(
                  inputBoxText: 'Password',
                  onChanged: (val) {
                    context.read<SignInCubit>().passwordChanged(val);
                  },
                  obscureText: signInState.isPasswordObscure,
                  onTapObscure: () { context.read<SignInCubit>().togglePasswordObscure(); },
                  validator: (String? val) => context.read<SignInCubit>().isPasswordValid(val!) ? null : "Enter Password",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Forgot Password?', style: TextStyle(color: Colors.white, fontSize: 18),),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20,),

                SizedBox(
                  width: 350,
                  height: 50,
                  child: signInState.signInStatus.isLoading
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : Utils.getCustomButton(
                        buttonText: 'Sign in',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignInCubit>().buttonClicked();
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
