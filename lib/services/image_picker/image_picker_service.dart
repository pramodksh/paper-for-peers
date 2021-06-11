import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/config/colors.dart';

class ImagePickerService {

  final ImagePicker picker = ImagePicker();

  Future<File> getCroppedImage({@required File imageFile}) async  {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: CustomColors.bottomNavBarColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    return croppedFile;
  }

  Future<File> getPickedImageAsFile({@required ImageSource imageSource}) async {
    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile == null) {
      return null;
    } else {
      return File(pickedFile.path);

    }
  }

}