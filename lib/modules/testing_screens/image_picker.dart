import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/services/image_picker/image_picker_service.dart';

class DemoImagePicker extends StatefulWidget {
  @override
  _DemoImagePickerState createState() => _DemoImagePickerState();
}

class _DemoImagePickerState extends State<DemoImagePicker> {

  File file;
  ImagePickerService imagePickerService = ImagePickerService();

  Future<File> getImage({@required ImageSource imageSource}) async {
    File file = await imagePickerService.getPickedImageAsFile(imageSource: ImageSource.gallery);
    file = await imagePickerService.getCroppedImage(imageFile: file);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            file != null ? Image.file(file) : Text("NO FILE"),
            ElevatedButton(
              onPressed: () async {
                File _pickedFile = await getImage(imageSource: ImageSource.gallery);
                setState(() {
                  file = _pickedFile;
                });
              },
              child: Text("Camera"),
            ),
            ElevatedButton(
              onPressed: () async {
                File _pickedFile = await getImage(imageSource: ImageSource.gallery);
                setState(() {
                  file = _pickedFile;
                });
              },
              child: Text("Galley"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  file = null;
                });
              },
              child: Text("CLear"),
            ),
          ],
        ),
      ),
    );
  }
}
