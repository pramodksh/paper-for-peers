import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/module/login/login.dart';

Widget customTextField({String inputBoxText, bool obscureText = false}) {
  return TextField(
    obscureText: obscureText,
    // textInputAction: ,
    decoration: InputDecoration(
      // contentPadding: EdgeInsets.symmetric(vertical: 10),
      isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(15.0),
        ),

        labelText: inputBoxText,
        labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black
          // height: 4
        )
    ),
  );
}




Widget customButton({@required String buttonText, @required Function onPressed, double width, double verticalPadding = 5 ,Color textColor = Colors.black}){
  Widget button = ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: verticalPadding)),
      backgroundColor: MaterialStateProperty.all(Colors.black12),
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