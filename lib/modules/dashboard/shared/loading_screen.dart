import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoadingScreen extends StatelessWidget {
  final String loadingText;
  LoadingScreen({this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              loadingText == null ? Container() : SizedBox(height: 20,),
              loadingText == null ? Container() : Text(
                loadingText,
                style: TextStyle(fontSize: 18,),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
