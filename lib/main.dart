import 'package:flutter/material.dart';
import 'package:papers_for_peers/modules/login/forgotPassword.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/modules/login/welcome.dart';
import 'package:papers_for_peers/modules/testing_screens/clip_background.dart';
import 'package:papers_for_peers/modules/testing_screens/pdf_view.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: "PorientOne",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: "PorientOne"),
          bodyText2: TextStyle(fontFamily: "PorientOne"),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),

      home: Login(),
      // home: welcomeScreens(),
      // home: Carousel(),
      // home: forgotPassword(),
      
      // home: PDFScreen(),
      // home: ClipPathScreen(),
    );
  }
}
