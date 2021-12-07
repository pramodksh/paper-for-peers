import 'package:flutter/material.dart';
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
  String get capitalized => this.toString().split(".").last.toLowerCase().capitalize();
}

class AppConstants {

  static const String KUDBaseURL = "https://www.kud.ac.in/";
  static const String KUDNotificationsURL = "https://www.kud.ac.in/cmsentities.aspx?type=notifications";

  static const List<Map> reportReasonsMap = [
    {"label": "Already Uploaded", "value": "already_uploaded"},
    {"label": "Not legitimate", "value": "not_legitimate"},
    {"label": "Not appropriate", "value": "not_appropriate"},
    {"label": "Misleading", "value": "misleading"},
  ];

  static const List<Map> bottomNavBarIcons = [
    {"icon": DefaultAssets.questionPaperNavIcon, "label": "Question Paper"},
    {"icon": DefaultAssets.notesNavIcon, "label": "Notes"},
    {"icon": DefaultAssets.journalNavIcon, "label": "Journal"},
    {"icon": DefaultAssets.syllabusCopyNavIcon, "label": "Syllabus Copy"},
    {"icon": DefaultAssets.textBookNavIcon, "label": "Text Book"},
  ];
}