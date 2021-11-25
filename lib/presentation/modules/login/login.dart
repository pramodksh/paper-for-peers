import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/shared_preference/shared_preference_repository.dart';
import 'package:papers_for_peers/logic/cubits/google_auth/google_auth_cubit.dart';
import 'package:papers_for_peers/logic/cubits/sign_in/sign_in_cubit.dart';
import 'package:papers_for_peers/logic/cubits/sign_up/sign_up_cubit.dart';
import 'package:papers_for_peers/presentation/modules/login/widgets/google_auth_widget.dart';
import 'package:papers_for_peers/presentation/modules/login/widgets/sign_in_form.dart';
import 'package:papers_for_peers/presentation/modules/login/widgets/sign_up_form.dart';
import 'package:papers_for_peers/presentation/modules/utils/login_utils.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  bool _isSignIn = true;
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpCubit(authRepository: context.read<AuthRepository>()),
        ),
        BlocProvider(
          create: (context) => SignInCubit(authRepository: context.read<AuthRepository>()),
        ),
        BlocProvider(
          create: (context) => GoogleAuthCubit(
            sharedPreferenceRepository: context.read<SharedPreferenceRepository>(),
            authRepository: context.read<AuthRepository>(), firestoreRepository: context.read<FirestoreRepository>(),
          ),
        ),
      ],
      child: Builder(
            builder: (context) {

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
                        child: Column(
                          children: [
                            _isSignIn ? SignInForm() : SignUpForm(),
                            SizedBox(height: 35,),
                            LoginUtils.getOrDivider(),
                            SizedBox(height: 30,),
                            GoogleAuthWidget(),
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
                            ),
                            SizedBox(height: 20,),
                          ],
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


