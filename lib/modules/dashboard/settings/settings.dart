import 'package:flutter/material.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {

    var themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Checkbox(
          value: themeChange.isDarkTheme,
          onChanged: (bool value) {  themeChange.isDarkTheme = value;},
        ),
      ),
    );
  }
}
