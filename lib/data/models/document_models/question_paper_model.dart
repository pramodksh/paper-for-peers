class QuestionPaperYearModel {
  int year;
  List<QuestionPaperModel> questionPaperModels;

  QuestionPaperYearModel({
    required this.year,
    required this.questionPaperModels,
  });
}

class QuestionPaperModel {
  final int version;
  final String url;
  final String uploadedBy;

  const QuestionPaperModel({
    required this.version,
    required this.url,
    required this.uploadedBy,
  });
}