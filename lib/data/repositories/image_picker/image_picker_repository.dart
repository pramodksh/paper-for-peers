import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart' as cropper;
import 'package:image_picker/image_picker.dart' as picker;
import 'package:papers_for_peers/config/export_config.dart';

abstract class BaseImagePickerRepository{
  Future<File?> getPickedImageAsFile({required picker.ImageSource imageSource});
  Future<File?> getCroppedImage({required File imageFile});
}

class ImagePickerRepository extends BaseImagePickerRepository {

  final picker.ImagePicker _imagePicker;

  ImagePickerRepository({picker.ImagePicker? imagePicker, cropper.ImageCropper? imageCropper})
    : _imagePicker = imagePicker ?? picker.ImagePicker();

  @override
  Future<File?> getCroppedImage({required File imageFile}) async {
    File? croppedFile = await cropper.ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          cropper.CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: cropper.AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: CustomColors.bottomNavBarColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: cropper.CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: cropper.IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    return croppedFile;
  }

  @override
  Future<File?> getPickedImageAsFile({required picker.ImageSource imageSource}) async {
    final pickedFile = await _imagePicker.getImage(source: imageSource);

    if (pickedFile == null) {
      return null;
    } else {
      return File(pickedFile.path);
    }

  }

}