import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/login/utilities.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';

class SendVerificationEmail extends StatefulWidget {
  final UserModel user;

  SendVerificationEmail({this.user});

  @override
  _SendVerificationEmailState createState() => _SendVerificationEmailState();
}

class _SendVerificationEmailState extends State<SendVerificationEmail> {

  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  Timer _timer;

  Future<bool> sendVerificationEmail() async {
    bool isSuccess = await _firebaseAuthService.sendVerificationEmail();
    return isSuccess;
  }

  @override
  void initState() {

    sendVerificationEmail().then((isSuccess) {
      if (!isSuccess) {
        showAlertDialog(context: context, text: "There was some error while sending verification Email");
      } else {
        Future(() async {
          _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
            print("RELOAD USER");
            await _firebaseAuthService.auth.currentUser.reload();
            User user = _firebaseAuthService.auth.currentUser;
            if (user.emailVerified) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => addUserIfNotExistsAndGetWidget(
                  context: context,
                  user: widget.user,
                ),
              ));
              timer.cancel();
            }
          });
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
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
                  'We will send you a verification link to\n\"${widget.user.email}\"',
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