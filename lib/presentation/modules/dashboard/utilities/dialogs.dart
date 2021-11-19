import 'package:flutter/material.dart';

Future showAlertDialog({required BuildContext context, required String? text}) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: Center(child: Text(text!)),
  ),
);