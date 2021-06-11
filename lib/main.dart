import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/dashboard/compare_question_paper/compare_question_paper.dart';
import 'package:papers_for_peers/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/modules/dashboard/profile/profile.dart';
import 'package:papers_for_peers/modules/dashboard/question_paper/question_paper.dart';
import 'package:papers_for_peers/modules/login/forgot_password.dart';
import 'package:papers_for_peers/modules/login/login.dart';
// import 'package:papers_for_peers/modules/login/carausel.dart';
import 'package:papers_for_peers/modules/login/user_details.dart';
import 'package:papers_for_peers/modules/login/welcome_message.dart';
import 'package:papers_for_peers/modules/testing_screens/clip_background.dart';
import 'package:papers_for_peers/modules/dashboard/notifications/notifications.dart';
import 'package:papers_for_peers/modules/testing_screens/image_picker.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'modules/dashboard/compare_question_paper/splitPDF.dart';
import 'modules/login/user_course.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.isDarkTheme =
    await themeChangeProvider.darkThemePreference.getAppTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.isDarkTheme, context),
            // home: Login(),
            // home: DemoImagePicker(),
            home: UserDetails(),
            // home: User,
          );
        },
      ),
    );
  }
}
