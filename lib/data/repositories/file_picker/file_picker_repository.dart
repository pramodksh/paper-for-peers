import 'dart:io';
import 'package:file_picker/file_picker.dart';

abstract class BaseFilePickerRepository {
  Future pickFile();
}

class FilePickerRepository extends BaseFilePickerRepository {

  @override
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }
}