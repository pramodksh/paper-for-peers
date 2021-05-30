import 'package:flutter/material.dart';

Widget getUploadButton({@required Function onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    onPressed: onPressed,
    child: Text("Upload", style: TextStyle(fontSize: 18),),
  );
}