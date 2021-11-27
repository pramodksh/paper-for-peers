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
    {"icon": AssetImage(DefaultAssets.questionPaperNavIcon,), "label": "Question Paper"},
    {"icon": AssetImage(DefaultAssets.notesNavIcon,), "label": "Notes"},
    {"icon": AssetImage(DefaultAssets.journalNavIcon,), "label": "Journal"},
    {"icon": AssetImage(DefaultAssets.syllabusCopyNavIcon,), "label": "Syllabus Copy"},
    // todo change icon of text book
    {"icon": AssetImage(DefaultAssets.syllabusCopyNavIcon,), "label": "Text Book"},
  ];

  static final int maxQuestionPapers = 3;
  static final int maxJournals = 2;
  static final int maxSyllabusCopy = 2;
  static final int maxTextBooks = 2;
  static final int maxNotesPerSubject = 15;
}