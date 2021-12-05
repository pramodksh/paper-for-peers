import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

class AppConstants {

  static const String KUDBaseURL = "https://www.kud.ac.in/";
  static const String KUDNotificationsURL = "https://www.kud.ac.in/cmsentities.aspx?type=notifications";

  // todo remove if not used
  static const List<String> reportReasons = [
    "Already uploaded",
    "Not legitimate",
    "Not appropriate",
    "Misleading",
  ];

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

  static final int maxQuestionPapers = 3;
  static final int maxJournals = 2;
  static final int maxSyllabusCopy = 2;
  static final int maxTextBooks = 2;
  static final int maxNotesPerSubject = 15;
}