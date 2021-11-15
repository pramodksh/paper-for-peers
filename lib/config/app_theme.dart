import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

enum AppThemeType {
  dark,
  light,
}

extension GetBoolValue on AppThemeType {

  bool isDarkTheme() {
    if (this == AppThemeType.dark) {
      return true;
    }
    return false;
  }

}

class Styles {

  static ThemeData themeData({required AppThemeType appThemeType, required BuildContext context}) {
    return ThemeData(

      dividerTheme: DividerThemeData(
        color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        thickness: 0.6,
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
        labelStyle: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
      ),


      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              CustomTextStyle.bodyTextStyle.copyWith(
                color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
              ),
            ),
          )
      ),

      // buttonTheme: ButtonThemeData(
      //   splashColor: Colors.red
      // ),



      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(appThemeType == AppThemeType.dark ? Colors.white : Colors.black,),
          backgroundColor: MaterialStateProperty.all(
            appThemeType == AppThemeType.dark ? CustomColors.ratingBackgroundColor : CustomColors.lightModeBottomNavBarColor,
          ),
          textStyle: MaterialStateProperty.all(
            CustomTextStyle.bodyTextStyle
          ),
        ),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
        backgroundColor: appThemeType == AppThemeType.dark ? CustomColors.backGroundColor : Colors.white,
        titleTextStyle: CustomTextStyle.appBarTextStyle.copyWith(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
        toolbarTextStyle: CustomTextStyle.appBarTextStyle.copyWith(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
      ),

      textTheme: TextTheme(
        bodyText1: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
        bodyText2: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
        subtitle1: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
        ),
      ).apply(
        // todo check and delete
        // bodyColor: Colors.white,
        // displayColor: Colors.white,
      ),

      // iconTheme: IconThemeData(
      //   color: Colors.red,
      //   // color: appThemeType == AppThemeType.dark ? CustomColors.bottomNavBarSelectedIconColor : Colors.red,
      // ),

      scaffoldBackgroundColor: appThemeType == AppThemeType.dark ? CustomColors.backGroundColor : Colors.white,

      // primarySwatch: Colors.red,
      // primaryColor: appThemeType == AppThemeType.dark ? Colors.black : Colors.white,
      //
      // backgroundColor: appThemeType == AppThemeType.dark ? Colors.black : Color(0xffF1F5FB),
      //
      // indicatorColor: appThemeType == AppThemeType.dark ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      // buttonColor: appThemeType == AppThemeType.dark ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      //
      // hintColor: appThemeType == AppThemeType.dark ? Color(0xff280C0B) : Color(0xffEECED3),
      //
      // highlightColor: appThemeType == AppThemeType.dark ? Color(0xff372901) : Color(0xffFCE192),
      // hoverColor: appThemeType == AppThemeType.dark ? Color(0xff3A3A3B) : Color(0xff4285F4),
      //
      // focusColor: appThemeType == AppThemeType.dark ? Color(0xff0B2512) : Color(0xffA8DAB5),
      // disabledColor: Colors.grey,
      // // textSelectionTheme: TextSelectionThemeData.lerp(a, b, t),
      // // textSelectionColor: appThemeType == AppThemeType.dark ? Colors.white : Colors.black,
      // cardColor: appThemeType == AppThemeType.dark ? Color(0xFF151515) : Colors.white,
      // canvasColor: appThemeType == AppThemeType.dark ? Colors.black : Colors.grey[50],
      // brightness: appThemeType == AppThemeType.dark ? Brightness.dark : Brightness.light,
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: appThemeType == AppThemeType.dark ? ColorScheme.dark() : ColorScheme.light()),
    );

  }
}