import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/dashboard/journal/journal.dart';
import 'package:papers_for_peers/modules/dashboard/notes/notes.dart';
import 'package:papers_for_peers/modules/dashboard/profile/profile.dart';
import 'package:papers_for_peers/modules/dashboard/question_paper/question_paper.dart';
import 'package:papers_for_peers/modules/dashboard/syllabus_copy/syllabus_copy.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:thememode_selector/thememode_selector.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  int selectedItemPosition = 0; // todo change to 0
  final double bottomNavBarRadius = 20;
  final double bottomNavBarHeight = 90;

  String get greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }


  @override
  Widget build(BuildContext context) {

    var themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      key: _scaffoldkey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
        child: Drawer(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: themeChange.isDarkTheme ? CustomColors.drawerColor : CustomColors.lightModeRatingBackgroundColor,
            child: Column(
              children: [
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Theme", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                    ThemeModeSelector(
                      durationInMs: 300,
                      height: 40,
                      onChanged: (mode) {
                        print('ThemeMode changed to $mode | ${mode == ThemeMode.light}');
                        if (mode == ThemeMode.light) {
                          themeChange.isDarkTheme = false;
                        } else {
                          themeChange.isDarkTheme = true;
                        }

                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(greeting),
        actions: [
          Transform.scale(
            scale: 1.1,
            child: IconButton(
              splashRadius: 25,
              icon: Image.asset(DefaultAssets.profileIcon, color: themeChange.isDarkTheme
                  ? CustomColors.bottomNavBarSelectedIconColor
                  : Colors.black.withOpacity(0.7),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ));
              },
            ),
          ),
          SizedBox(width: 15,),
          Transform.scale(
            scale: 1.1,
            child: IconButton(
              splashRadius: 25,
              icon: Image.asset(DefaultAssets.settingIcon, color: themeChange.isDarkTheme
                  ? CustomColors.bottomNavBarSelectedIconColor
                  : Colors.black.withOpacity(0.7),
              ),
              onPressed: () {
                _scaffoldkey.currentState.openEndDrawer();
              },
            ),
          ),
          SizedBox(width: 5,),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (selectedItemPosition == 0) {
            return QuestionPaper(isDarkTheme: themeChange.isDarkTheme,);
          } else if (selectedItemPosition == 1) {
            return Notes(isDarkTheme: themeChange.isDarkTheme,);
          } else if (selectedItemPosition == 2) {
            return Journal(isDarkTheme: themeChange.isDarkTheme,);
          } else {
            return SyllabusCopy();
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: themeChange.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(bottomNavBarRadius),
            topLeft: Radius.circular(bottomNavBarRadius),
          ),
        ),
        height: 75,
        child: Builder(
          builder: (context) {

            Color selectedIconColor;
            Color unselectedIconColor;

            if (themeChange.isDarkTheme) {
              selectedIconColor = CustomColors.bottomNavBarSelectedIconColor;
              unselectedIconColor = CustomColors.bottomNavBarUnselectedIconColor;
            } else {
              selectedIconColor = CustomColors.lightModeBottomNavBarSelectedIconColor;
              unselectedIconColor = CustomColors.lightModeBottomNavBarUnselectedIconColor;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  AppConstants.bottomNavBarIcons.length, (index) => SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.7,
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            // constraints: BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                selectedItemPosition = index;
                              });
                            },
                            icon: ImageIcon(
                              AppConstants.bottomNavBarIcons[index]["icon"],
                              color: selectedItemPosition == index
                                  ? selectedIconColor
                                  : unselectedIconColor,
                            ),
                          ),
                        ),
                        selectedItemPosition == index ? Text(
                          AppConstants.bottomNavBarIcons[index]["label"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedIconColor,
                            fontSize: 12,
                          ),
                        ) : Container(),
                      ],
                    ),
                  )
              ),
            );
          },
        ),
      ),
    );
  }
}
