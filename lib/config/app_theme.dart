import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(


      inputDecorationTheme: InputDecorationTheme(
        labelStyle: CustomTextStyle.bodyTextStyle.copyWith(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ),


      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              CustomTextStyle.bodyTextStyle.copyWith(
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          )
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            CustomTextStyle.bodyTextStyle.copyWith(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        textTheme: TextTheme(
          headline6: CustomTextStyle.appBarTextStyle.copyWith(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),

      textTheme: TextTheme(
        bodyText1: CustomTextStyle.bodyTextStyle.copyWith(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        bodyText2: CustomTextStyle.bodyTextStyle.copyWith(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ).apply(
        // todo check and delete
        // bodyColor: Colors.white,
        // displayColor: Colors.white,
      ),

      // todo change color
      scaffoldBackgroundColor: isDarkTheme ? Colors.white : Colors.black,

      // primarySwatch: Colors.red,
      // primaryColor: isDarkTheme ? Colors.black : Colors.white,
      //
      // backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
      //
      // indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      //
      // hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      //
      // highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      //
      // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      // disabledColor: Colors.grey,
      // // textSelectionTheme: TextSelectionThemeData.lerp(a, b, t),
      // // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      // canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      // brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
    );

  }
}