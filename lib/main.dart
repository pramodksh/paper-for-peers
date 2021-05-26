import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/login/forgotPassword.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/modules/login/welcome.dart';
import 'package:papers_for_peers/modules/testing_screens/clip_background.dart';
import 'package:papers_for_peers/modules/testing_screens/pdf_view.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
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
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
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
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),

            // theme: ThemeData(
            //   // buttonTheme: ButtonThemeData(
            //   //   splashColor:
            //   // ),
            //
            //   inputDecorationTheme: InputDecorationTheme(
            //     labelStyle: CustomTextStyle.bodyTextStyle,
            //   ),
            //
            //   textButtonTheme: TextButtonThemeData(
            //       style: ButtonStyle(
            //         textStyle: MaterialStateProperty.all(TextStyle(fontFamily: "Montserrat")),
            //       )
            //   ),
            //
            //   elevatedButtonTheme: ElevatedButtonThemeData(
            //     style: ButtonStyle(
            //       textStyle: MaterialStateProperty.all(CustomTextStyle.bodyTextStyle),
            //     ),
            //   ),
            //
            //   appBarTheme: AppBarTheme(
            //     backgroundColor: Colors.black,
            //     textTheme: TextTheme(
            //       headline6: CustomTextStyle.appBarTextStyle,
            //     ),
            //   ),
            //
            //   textTheme: TextTheme(
            //     bodyText1: CustomTextStyle.bodyTextStyle,
            //     bodyText2: CustomTextStyle.bodyTextStyle,
            //   ).apply(
            //     bodyColor: Colors.white,
            //     displayColor: Colors.white,
            //   ),
            //
            //   visualDensity: VisualDensity.adaptivePlatformDensity,
            //   scaffoldBackgroundColor: Colors.black,
            //
            // ),

            home: Login(),
            // home: welcomeScreens(),
            // home: Carousel(),

            // home: PDFScreen(),
            // home: ClipPathScreen(),
          );
        },
      ),
    );
  }
}
