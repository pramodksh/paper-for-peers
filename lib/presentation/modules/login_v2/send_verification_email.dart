import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/presentation/modules/utils/login_utils.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class SendVerificationEmail extends StatefulWidget {
  final UserModel? user;

  SendVerificationEmail({this.user});

  @override
  _SendVerificationEmailState createState() => _SendVerificationEmailState();
}

class _SendVerificationEmailState extends State<SendVerificationEmail> {

  Timer? _timer;

  Future<bool> sendVerificationEmail({required AuthRepository authRepository}) async {
    bool isSuccess = await authRepository.sendVerificationEmail();
    return isSuccess;
  }

  @override
  void initState() {

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      AuthRepository _authRepository = context.read<AuthRepository>();
      sendVerificationEmail(authRepository: _authRepository).then((isSuccess) {
        if (!isSuccess) {
          Utils.showAlertDialog(context: context, text: "There was some error while sending verification Email");
        } else {
          Future(() async {
            _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
              await _authRepository.reloadCurrentUser();
            });
          });
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();

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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mark_email_read_outlined, size: 60, color: Colors.white,),
                SizedBox(height: 50,),
                Text(
                  "Send Verification Email",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 70,
                ),
                Text(
                  'We will send you a verification link to\n\"${widget.user!.email}\"',
                  style: CustomTextStyle.bodyTextStyle.copyWith(fontSize: 18),
                  // style: TextStyle(fontSize: 15,),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
