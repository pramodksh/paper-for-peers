import 'package:flutter/material.dart';
import 'package:papers_for_peers/modules/dashboard/profile/profile.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';

class UploadPost extends StatefulWidget {
  final String label;
  final TypesOfPost typesOfPost;

  UploadPost({this.label, this.typesOfPost});

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload ${widget.label}",
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: getAddPostContainer(
                context: context,
                label: "Select File",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
