import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Transform.scale(
            scale: 1.2,
            child: IconButton(
              splashRadius: 25,
              icon: Image.asset(DefaultAssets.profileIcon,),
              onPressed: () { },
            ),
          ),
          SizedBox(width: 15,),
          Transform.scale(
            scale: 1.2,
            child: IconButton(
              splashRadius: 25,
              icon: Image.asset(DefaultAssets.settingIcon,),
              onPressed: () { },
            ),
          ),
          SizedBox(width: 5,),
        ],
      ),
    );
  }
}
