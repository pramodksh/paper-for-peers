import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {

  final AppThemeType appThemeType;
  final Widget child;

  const SkeletonLoader({
    required this.appThemeType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
      highlightColor: appThemeType.isDarkTheme() ? CustomColors.backGroundColor : Colors.white,
      child: child,
    );
  }
}
