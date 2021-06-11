import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {

  final ImagePicker picker = ImagePicker();

  Future<File> getPickedImageAsFile({@required ImageSource imageSource}) async {
    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile == null) {
      return null;
    } else {
      return File(pickedFile.path);

    }
  }

}