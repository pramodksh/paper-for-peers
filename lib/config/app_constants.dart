import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

class AppConstants {

  static const String KUDNotificationsURL = "https://www.kud.ac.in/cmsentities.aspx?type=notifications";

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
    {"icon": AssetImage(DefaultAssets.syllabusCopyNavIcon,), "label": "Syllabus Copy"},
  ];

}