import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/google_auth/google_auth_cubit.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class GoogleAuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoogleAuthState googleAuthState = context.watch<GoogleAuthCubit>().state;

    return BlocListener<GoogleAuthCubit, GoogleAuthState>(
      listener: (context, state) {
        if (state.googleAuthStatus.isError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        }
      },
      child: TextButton(
        onPressed: googleAuthState.googleAuthStatus.isLoading ? null : () {
          context.read<GoogleAuthCubit>().authenticateWithGoogle();
        },
        child: googleAuthState.googleAuthStatus.isLoading ? Center(
          child: CircularProgressIndicator.adaptive(),
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              DefaultAssets.googleIconPath,
              height: 30,
            ),
            SizedBox(width: 15,),
            Text(
              'Continue with Google',
              style: TextStyle(color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
