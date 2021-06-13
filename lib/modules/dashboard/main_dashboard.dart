import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/dashboard/journal/journal.dart';
import 'package:papers_for_peers/modules/dashboard/notes/notes.dart';
import 'package:papers_for_peers/modules/dashboard/profile/profile.dart';
import 'package:papers_for_peers/modules/dashboard/question_paper/question_paper.dart';
import 'package:papers_for_peers/modules/dashboard/syllabus_copy/syllabus_copy.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/modules/dashboard/notifications/notifications.dart';
import 'package:papers_for_peers/modules/login/login.dart';
import 'package:papers_for_peers/services/firebase_auth/firebase_auth_service.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  int selectedItemPosition = 0;
  final double bottomNavBarRadius = 20;
  final double bottomNavBarHeight = 90;

  String selectedSemester;


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

  // Widget getDrawer({bool isDarkTheme}) =>

  @override
  Widget build(BuildContext context) {

    var themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      key: _scaffoldkey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
        child: Drawer(
          child: Container(
            color: themeChange.isDarkTheme ? CustomColors.drawerColor : CustomColors.lightModeRatingBackgroundColor,
            child: Column(
              children: [
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      themeChange.isDarkTheme ? "Switch to\nLight Theme" : "Switch to\nDark Theme",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600
                      ),
                    ),
                    CupertinoSwitch(
                      trackColor: CustomColors.bottomNavBarColor,
                      activeColor: CustomColors.lightModeBottomNavBarColor,
                      onChanged: (val) { setState(() {  themeChange.isDarkTheme = val; }); },
                      value:  themeChange.isDarkTheme,
                    ),
                  ],
                ),
                Divider(height: 50,),
                Text(
                  "Change Semester",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: 180,
                  child: getCustomDropDown(
                    context: context,
                    dropDownHint: "Semester",
                    dropDownItems: List.generate(6, (index) => (index + 1).toString()),
                    onDropDownChanged: (val) { setState(() { selectedSemester = val; }); },
                    dropDownValue: selectedSemester,
                  ),
                ),
                Divider(height: 40,),
                Spacer(),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    onPressed: () {},
                    child: Text("Contact Us", style: TextStyle(fontSize: 18),),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    onPressed: () async {
                      await FirebaseAuthService().logoutUser();
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //   builder: (context) => Login(),
                        // ));
                      });
                    },
                    child: Text("Log Out", style: TextStyle(fontSize: 18),),
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(greeting, style: TextStyle(fontSize: 20),),
        actions: [
          IconButton(
            splashRadius: 25,
            icon: Icon(CupertinoIcons.bell_fill, size: 32,),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Notifications(),
                // builder: (context) => CompareQuestionPaper(),
              ));
            },
          ),
          SizedBox(width: 15,),
          IconButton(
            splashRadius: 25,
            icon: Icon(Icons.account_circle, size: 32,),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ));
            },
          ),
          SizedBox(width: 15,),
          IconButton(
            splashRadius: 25,
            icon: Icon(Icons.settings, size: 32,),
            onPressed: () {
              _scaffoldkey.currentState.openEndDrawer();
            },
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
        height: 90,
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
                    width: MediaQuery.of(context).size.width / AppConstants.bottomNavBarIcons.length,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.5,
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
