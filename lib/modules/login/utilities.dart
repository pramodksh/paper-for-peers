import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

Widget getCustomPasswordField({
  @required TextEditingController controller,
  @required Function validator,
  String inputBoxText,
  bool obscureText = true,
  VoidCallback onTapObscure,
}) {
  return TextFormField(
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


Widget getCustomTextField({
  @required TextEditingController controller,
  @required Function validator,
  String labelText,
  String hintText,
  bool obscureText = false,
  Function onChanged,
}) {
  return TextFormField(
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

Widget getCustomButton({@required String buttonText, @required Function onPressed, double width, double verticalPadding = 5 ,Color textColor = Colors.white}){
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