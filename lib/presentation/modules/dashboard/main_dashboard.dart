
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:papers_for_peers/config/app_constants.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/profile.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/question_paper/question_paper.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/syllabus_copy/syllabus_copy.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/text_book/text_book.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';

import 'journal/journal.dart';
import 'notes/notes.dart';
import 'notifications/notifications.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  String _loadingText = "";

  int selectedItemPosition = 0;
  final double bottomNavBarRadius = 20;
  final double bottomNavBarHeight = 90;

  String? selectedSemester;


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

  AppBar getAppBar() {
    return AppBar(
      title: Text(greeting, style: TextStyle(fontSize: 20),),
      actions: [
        IconButton(
          splashRadius: 25,
          icon: Icon(CupertinoIcons.bell_fill, size: 32,),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Notifications(),
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
            _scaffoldkey.currentState!.openEndDrawer();
          },
        ),
        SizedBox(width: 5,),
      ],
    );
  }

  Drawer getDrawer({required bool isDarkTheme}) {
    return Drawer(
      child: Container(
        color: isDarkTheme ? CustomColors.drawerColor : CustomColors.lightModeRatingBackgroundColor,
        child: Column(
          children: [
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  isDarkTheme ? "Switch to\nLight Theme" : "Switch to\nDark Theme",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600
                  ),
                ),
                CupertinoSwitch(
                  trackColor: CustomColors.bottomNavBarColor,
                  activeColor: CustomColors.lightModeBottomNavBarColor,
                  onChanged: (val) {
                    context.read<AppThemeCubit>().toggle();
                  },
                  value: isDarkTheme,
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
              child: getCustomDropDown<String>(
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
                  if (mounted) {
                    setState(() { _isLoading = true; _loadingText = "Logging out.."; });
                  }
                  await context.read<AuthRepository>().logoutUser();
                  if (mounted) {
                    setState(() { _isLoading = false; });
                  }

                  // todo check logging out when user first signs up
                  // print("CAP POP: ${Navigator.of(context).canPop()}");
                  // SchedulerBinding.instance.addPostFrameCallback((_) {
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (context) => Login(),
                  //   ));
                  // });
                },
                child: Text("Log Out", style: TextStyle(fontSize: 18),),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget getBottomNavBar({required bool isDarkTheme}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
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

          if (isDarkTheme) {
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
    );
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    return Scaffold(
      key: _scaffoldkey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
        child: getDrawer(isDarkTheme: appThemeType.isDarkTheme()),
      ),
      appBar: getAppBar(),
      body: Builder(
        builder: (context) {
          if (_isLoading ) {
            return LoadingScreen(loadingText: _loadingText,);
          } else if (selectedItemPosition == 0) {
            return QuestionPaper();
          } else if (selectedItemPosition == 1) {
            return Notes();
          } else if (selectedItemPosition == 2) {
            return Journal();
          } else if (selectedItemPosition == 3) {
            return SyllabusCopy();
          } else {
            return TextBook();
          }
        },
      ),
      bottomNavigationBar: getBottomNavBar(isDarkTheme: appThemeType.isDarkTheme()),
    );
  }
}
