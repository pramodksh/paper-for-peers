import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

enum AppThemeType {
  dark,
  light,
}

extension AppThemeTypeExtension on AppThemeType {

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
        color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        thickness: 0.6,
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
        labelStyle: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              CustomTextStyle.bodyTextStyle.copyWith(
                color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
              ),
            ),
          )
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(appThemeType.isDarkTheme() ? Colors.white : Colors.black,),
          backgroundColor: MaterialStateProperty.all(
            appThemeType.isDarkTheme() ? CustomColors.ratingBackgroundColor : CustomColors.lightModeBottomNavBarColor,
          ),
          textStyle: MaterialStateProperty.all(
            CustomTextStyle.bodyTextStyle
          ),
        ),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
        backgroundColor: appThemeType.isDarkTheme() ? CustomColors.backGroundColor : Colors.white,
        titleTextStyle: CustomTextStyle.appBarTextStyle.copyWith(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
        toolbarTextStyle: CustomTextStyle.appBarTextStyle.copyWith(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
      ),

      textTheme: TextTheme(
        bodyText1: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
        bodyText2: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
        subtitle1: CustomTextStyle.bodyTextStyle.copyWith(
          color: appThemeType.isDarkTheme() ? Colors.white : Colors.black,
        ),
      ),

      scaffoldBackgroundColor: appThemeType.isDarkTheme() ? CustomColors.backGroundColor : Colors.white,

    );

  }
}