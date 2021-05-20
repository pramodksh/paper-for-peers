import 'package:flutter/material.dart';
import 'package:papers_for_peers/module/login/forgotPassword.dart';
import 'package:papers_for_peers/module/login/login.dart';
import 'package:papers_for_peers/module/login/welcome.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
