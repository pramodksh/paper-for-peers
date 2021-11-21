class TextBookSubjectModel {
  String subject;
  List<TextBookModel> textBookModels;

  TextBookSubjectModel({
    required this.subject,
    required this.textBookModels,
  });
}

class TextBookModel {
  final int version;
  final String url;
  final String uploadedBy;
  final DateTime uploadedOn;

  const TextBookModel({
    required this.version,
    required this.url,
    required this.uploadedBy,
    required this.uploadedOn,
  });
}