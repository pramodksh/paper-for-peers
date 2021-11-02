import 'package:flutter/material.dart';

class CustomRect extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(0.0, size.width * 2, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class ClipTesting extends StatefulWidget {
  @override
  _ClipTestingState createState() => _ClipTestingState();
}

class _ClipTestingState extends State<ClipTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CLIP"),
      ),
      body: Center(
        child: ClipOval(
          child: Container(
            color: Colors.red,
            width: 300.0,
            height: 200.0,
          ),
        ),
      )
    );
  }
}
