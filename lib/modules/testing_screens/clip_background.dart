import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  var radius=20.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 500);
    path.lineTo(200,200);
    path.lineTo(260,0);
    path.lineTo(30, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class ClipPathScreen extends StatefulWidget {
  @override
  _ClipPathScreenState createState() => _ClipPathScreenState();
}

class _ClipPathScreenState extends State<ClipPathScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clip path"),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
                color:Colors.white
            ),
            ClipPath(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.yellow,
              ),
              clipper: CustomClipPath(),
            )
          ],
        ),
      )
    );
  }
}
