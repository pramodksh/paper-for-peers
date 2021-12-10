import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_compressor/pdf_compressor.dart';

abstract class BaseFilePickerRepository {
  Future pickFile();
}

class FilePickerRepository extends BaseFilePickerRepository {

  String getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future<String> getTempPath() async {
    var dir = await getExternalStorageDirectory();
    await new Directory('${dir!.path}/CompressPdfs').create(recursive: true);

    String randomString = getRandomString(10);
    String pdfFileName = '$randomString.pdf';
    return '${dir.path}/CompressPdfs/$pdfFileName';
  }


  @override
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      print("SIZE: OLD: ${file.lengthSync()}");
      String outputPath = await getTempPath();
      try {
        await PdfCompressor.compressPdfFile(file.path, outputPath, CompressQuality.MEDIUM);
        print("SIZE: NEW: ${File(outputPath).lengthSync()}");
        return File(outputPath);
      } on Exception catch (e) {
        return null;
      }

    } else {
      return null;
    }
  }
}