import 'package:flutter/material.dart';

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
        )),
  );
}