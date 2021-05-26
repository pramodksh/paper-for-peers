import 'package:flutter/material.dart';
import 'package:papers_for_peers/services/shared_preferences/shared_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _isDarkTheme = true;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    darkThemePreference.setAppTheme(value);
    notifyListeners();
  }
}