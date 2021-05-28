import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/config/text_styles.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

Widget getCourseText({@required String course, @required int semester}) {
  return Text("$course $semester", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),);
}

Widget getCustomDropDown({
  @required BuildContext context,
  @required String dropDownValue,
  @required List<String> dropDownItems,
  @required String dropDownHint,
  @required Function onDropDownChanged,
}) {

  var themeChange = Provider.of<DarkThemeProvider>(context);

  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: themeChange.isDarkTheme ? CustomColors.bottomNavBarColor : Colors.grey.shade300,
    ),
    child: Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: themeChange.isDarkTheme ? CustomColors.bottomNavBarColor : Colors.grey.shade300,
          border: Border.all(color: Colors.black54,)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          iconSize: 30,
          icon: Icon(Icons.keyboard_arrow_down),
          value: dropDownValue,
          hint: Text(dropDownHint, style: CustomTextStyle.bodyTextStyle.copyWith(
            fontSize: 18,
            color: themeChange.isDarkTheme ? Colors.white60 : Colors.black,
          ),),
          items: dropDownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: CustomTextStyle.bodyTextStyle.copyWith(
                fontSize: 18,
                color: themeChange.isDarkTheme ? Colors.white60 : Colors.black,
              ),),
            );
          }).toList(),
          onChanged: onDropDownChanged,
        ),
      ),
    ),
  );
}

Widget getAddPostContainer({
  @required String label,
  @required Function onPressed,
  @required BuildContext context,
  bool isExpanded = false,
  double containerHeight = 80,
  double containerWidth = 180,
  double containerMargin = 20,
  double containerRadius = 15,
}) {

  var themeChange = Provider.of<DarkThemeProvider>(context);

  Widget dottedBorderContainer = DottedBorder(
    padding: EdgeInsets.zero,
    // todo check this glitch
    color: themeChange.isDarkTheme ? CustomColors.bottomNavBarUnselectedIconColor : CustomColors.lightModeBottomNavBarUnselectedIconColor,
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

  if (isExpanded) {
    return dottedBorderContainer;
  }
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: containerHeight,
      width: containerWidth,
      // color: Colors.transparent,
      margin: EdgeInsets.only(right: containerMargin),
      child: dottedBorderContainer,
    ),
  );
}