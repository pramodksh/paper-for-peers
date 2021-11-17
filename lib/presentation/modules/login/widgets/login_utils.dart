import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

class LoginUtils {
  static Widget getOrDivider() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(height: 2.0, color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          child: Text("OR", style: CustomTextStyle.bodyTextStyle.copyWith(letterSpacing: 4),),
        ),
        Expanded(
          child: Container(
            height: 2.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

}