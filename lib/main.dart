import 'package:flutter/material.dart';
import 'package:papers_for_peers/modules/login/forgotPassword.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/modules/login/welcome.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: "Mulish",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          // bodyText1: TextStyle(fontFamily: "Mulish"),
          // bodyText2: TextStyle(fontFamily: "Mulish"),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      // initialRoute: '/',
        // routes: {
        // '/': (context) => Loading(),
        // '/homePage': (context) => HomePage(),
        // '/chooseLocation': (context) => ChooseLocation(),

      // initialRoute: '/',
      // routes: {
      //   '/' :(context) => Login(),
      //   '/'
      // },


      home: Login(),
      // home: welcomeScreens(),
      // home: Carousel(),
      // home: forgotPassword(),
    );
  }
}
