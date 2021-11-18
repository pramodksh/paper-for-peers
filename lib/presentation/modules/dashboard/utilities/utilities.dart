import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/config/text_styles.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:provider/provider.dart';

Widget getCourseAndSemesterText({required BuildContext context}) {
  UserState state = context.select((UserCubit cubit) => cubit.state);

  if (state is UserLoaded) {
    return Text("${state.userModel.course!.courseName} ${state.userModel.semester!.semester}", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),);
  } else {
    return Container();
  }
}

Widget getCustomDropDown<DropdownItemType>({
  required BuildContext context,
  required DropdownItemType? dropDownValue,
  required List<DropdownItemType>? dropDownItems,
  required String dropDownHint,
  required Function(DropdownItemType?)? onDropDownChanged,
  List<DropdownMenuItem<DropdownItemType>>? items,
  Function()? onDropDownTap,
  bool isTransparent = false
}) {

  final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
  Color backgroundColor;
  Border border;

  if (items == null) {
    items = dropDownItems?.map((DropdownItemType value) {
      return DropdownMenuItem<DropdownItemType>(
        value: value,
        child: Text(value.toString(), style: CustomTextStyle.bodyTextStyle.copyWith(
          fontSize: 18,
          color: appThemeType.isDarkTheme() ? Colors.white60 : Colors.black,
        ),),
      );
    }).toList();
  }

  if (isTransparent) {
    backgroundColor = Colors.transparent;
    border = Border.all(color: Colors.white, width: 2);
  } else {
    backgroundColor = appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : Colors.grey.shade300;
  border = Border.all(color: Colors.black54,);
  }

  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : Colors.grey.shade300,
    ),
    child: Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: backgroundColor,
          border: border,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DropdownItemType>(
          onTap: onDropDownTap,
          isExpanded: true,
          iconSize: 30,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: appThemeType.isDarkTheme() ? Colors.grey.shade300 : CustomColors.bottomNavBarColor,
          ),
          value: dropDownValue,
          hint: Text(dropDownHint, style: CustomTextStyle.bodyTextStyle.copyWith(
            fontSize: 18,
            color: appThemeType.isDarkTheme() ? Colors.white60 : Colors.black,
          ),),
          items: items,
          onChanged: onDropDownChanged,
        ),
      ),
    ),
  );
}

Widget getAddPostContainer({
  required bool isDarkTheme,
  required String label,
  required Function() onPressed,
  required BuildContext context,
  double containerRadius = 15,
}) {

  Widget dottedBorderContainer = DottedBorder(
    padding: EdgeInsets.zero,
    color: isDarkTheme ? CustomColors.bottomNavBarUnselectedIconColor : CustomColors.lightModeBottomNavBarUnselectedIconColor,
    dashPattern: [8, 4],
    strokeWidth: 2,
    strokeCap: StrokeCap.square,
    borderType: BorderType.RRect,
    radius: Radius.circular(containerRadius),
    child: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: CustomColors.bottomNavBarUnselectedIconColor, fontWeight: FontWeight.w500)),
          SizedBox(height: 8,),
          Image.asset(
            DefaultAssets.addPostIcon,
            color: CustomColors.bottomNavBarUnselectedIconColor,
            scale: 0.9,
          ),
        ],
      ),
    ),
  );

  return GestureDetector(
    onTap: onPressed,
    child: dottedBorderContainer,
  );

}

String getUserNameForProfilePhoto(String userName) {
  if (userName.isEmpty) {
    return "";
  } else {
    List<String> list = userName.split(" ").map((e) => e.isEmpty ? "" : e[0].toUpperCase()).toList();
    if (list.length <= 2) {
      return list.join();
    } else {
      return list.join().substring(0, 2);
    }
  }
}