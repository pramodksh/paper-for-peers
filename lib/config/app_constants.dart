import 'package:papers_for_peers/config/export_config.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

enum DocumentType {
  JOURNAL,
  SYLLABUS_COPY,
  QUESTION_PAPER,
  NOTES,
  TEXT_BOOK,
}

extension DocumentTypeExtension on DocumentType {
  String get toUpper => this.toString().split(".").last.toUpperCase();
  String get capitalized => this.toString().split(".").last.toLowerCase().replaceAll("_", " ").capitalize();
}

class AppConstants {

  static const String KUDBaseURL = "https://www.kud.ac.in/";
  static const String KUDNotificationsURL = "https://www.kud.ac.in/cmsentities.aspx?type=notifications";

  static late List<String> reportReasons;

  static const List<Map> bottomNavBarIcons = [
    {"icon": DefaultAssets.questionPaperNavIcon, "label": "Question Paper"},
    {"icon": DefaultAssets.notesNavIcon, "label": "Notes"},
    {"icon": DefaultAssets.journalNavIcon, "label": "Journal"},
    {"icon": DefaultAssets.syllabusCopyNavIcon, "label": "Syllabus Copy"},
    {"icon": DefaultAssets.textBookNavIcon, "label": "Text Book"},
  ];
}