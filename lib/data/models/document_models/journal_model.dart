class JournalSubjectModel {
  String subject;
  List<JournalModel> journalModels;

  JournalSubjectModel({
    required this.subject,
    required this.journalModels,
  });
}

class JournalModel {
  final int version;
  final String url;
  final String uploadedBy;
  final DateTime uploadedOn;

  const JournalModel({
    required this.version,
    required this.url,
    required this.uploadedBy,
    required this.uploadedOn,
  });
}