import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:provider/provider.dart';

class Utils {

  static Future showAlertDialog({required BuildContext context, required String text}) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      titlePadding: EdgeInsets.all(30),
      contentPadding: EdgeInsets.all(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: context.select((AppThemeCubit cubit) => cubit.state).appThemeType.isDarkTheme() ? CustomColors.reportDialogBackgroundColor : CustomColors.lightModeBottomNavBarColor,
      title: Center(child: Text(text, style: TextStyle(fontSize: 18),),),
    ),
  );

  static Widget getCourseAndSemesterText({required BuildContext context}) {
    UserState state = context.select((UserCubit cubit) => cubit.state);

    if (state is UserLoaded) {
      return Text("${state.userModel.course!.courseName!.toUpperCase()} ${state.userModel.semester!.nSemester}", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),);
    } else {
      return Container();
    }
  }

  static Widget getProfilePhotoWidget({
    required String? url, required String username,
    double radius = 20, double fontSize = 16,
  }) {

    if (url == null) {
      return CircleAvatar(
        radius: radius,
        child: Text(Utils.getUserNameForProfilePhoto(username), style: TextStyle(fontSize: fontSize),),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      errorWidget: (context, url, error) {
        return CircleAvatar(
          radius: radius,
          child: Center(child: Icon(Icons.error),),
        );
      },
      progressIndicatorBuilder: (context, url, progress) {
        return CircleAvatar(
          radius: radius,
          child: Center(child: CircularProgressIndicator.adaptive(),),
        );
      },
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
        );
      },
    );
  }

  static Widget getCustomDropDown<DropdownItemType>({
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

  static Widget getAddPostContainer({
    required bool isDarkTheme,
    required String label,
    required Function() onPressed,
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

  static String getUserNameForProfilePhoto(String userName) {
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

  static Widget getCustomPasswordField({
    required String? Function(String?)? validator,
    TextEditingController? controller,
    String? inputBoxText,
    bool obscureText = true,
    VoidCallback? onTapObscure,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      style: TextStyle(fontSize: 16, color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          splashRadius: 20,
          onPressed: onTapObscure,
          icon: obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          color: Colors.white,
        ),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: inputBoxText,
        errorStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  static Widget getCustomTextField({
    required String? Function(String?)? validator,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    bool obscureText = false,
    Function(String)? onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      style: TextStyle(fontSize: 16, color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: labelText,
        hintText: hintText,
        errorStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  static Widget getCustomButton({
    required String buttonText, required Function() onPressed,
    double? width, double verticalPadding = 5 ,Color textColor = Colors.white
  }){
    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: verticalPadding)),
        backgroundColor: MaterialStateProperty.all(Colors.white38),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
                side: BorderSide(
                    color: Colors.transparent,
                    width: 200
                )
            )
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: textColor),
      ),
    );

    if (width == null) {
      return button;
    } else {
      return SizedBox(width: width, child: button,);
    }

  }

  static void showToast({required String label}) {
    Fluttertoast.showToast(
        msg: label,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: CustomColors.bottomNavBarColor,
        textColor: Colors.white,
        fontSize: 18.0
    );
  }
}