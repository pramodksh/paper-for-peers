import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

enum TypesOfPost {
  QuestionPaper,
  Notes,
  SyllabusCopy,
  Journal,
}

class AppConstants {
  static const List<String> reportReasons = [
    "Already uploaded",
    "Not legitimate",
    "Not appropriate",
    "Misleading",
  ];

  static const List<Map> bottomNavBarIcons = [
    {"icon": AssetImage(DefaultAssets.questionPaperNavIcon,), "label": "Question Paper"},
    {"icon": AssetImage(DefaultAssets.notesNavIcon,), "label": "Notes"},
    {"icon": AssetImage(DefaultAssets.journalNavIcon,), "label": "Journal"},
    {"icon": AssetImage(DefaultAssets.syllabusCopyNavIcon,), "label": "Syllabus Copy"},
  ];

}