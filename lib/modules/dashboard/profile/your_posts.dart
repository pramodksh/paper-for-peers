import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/post_tiles.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class YourPosts extends StatefulWidget {
  @override
  _YourPostsState createState() => _YourPostsState();
}

class _YourPostsState extends State<YourPosts> with TickerProviderStateMixin {

  int selectedItemPosition = 0;
  TabController _tabController;
  double tabBarViewPadding = 10;

  @override
  void initState() {
    _tabController = new TabController(length: AppConstants.bottomNavBarIcons.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var themeChange = Provider.of<DarkThemeProvider>(context);

    Color selectedIconColor;
    Color unselectedIconColor;

    if (themeChange.isDarkTheme) {
      selectedIconColor = CustomColors.bottomNavBarSelectedIconColor;
      unselectedIconColor = CustomColors.bottomNavBarUnselectedIconColor;
    } else {
      selectedIconColor = CustomColors.lightModeBottomNavBarSelectedIconColor;
      unselectedIconColor = CustomColors.lightModeBottomNavBarUnselectedIconColor;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Posts"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: TabBar(
                controller: _tabController,
                indicatorColor: themeChange.isDarkTheme ? CustomColors.lightModeBottomNavBarColor : CustomColors.bottomNavBarColor,
                unselectedLabelColor: unselectedIconColor,
                labelColor: selectedIconColor,
                tabs: List.generate(AppConstants.bottomNavBarIcons.length, (index) => Tab(
                  text: AppConstants.bottomNavBarIcons[index]["label"],
                  icon: ImageIcon(
                    AppConstants.bottomNavBarIcons[index]["icon"],
                    color: selectedItemPosition == index
                        ? selectedIconColor
                        : unselectedIconColor,
                  ),
                )
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Center(
                    child: Text('It\'s cloudy here'),
                  ),
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
                    children: List.generate(10, (index) {
                      return getNotesDetailsTile(
                        isYourPostTile: true,
                        context: context,
                        onTileTap: () {},
                        title: "Title Title Title",
                        description: "Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
                        rating: 3.5,
                      );
                    }),
                  ),
                  Center(
                    child: Text('It\'s rainy here'),
                  ),
                  Center(
                    child: Text('It\'s sunny here'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
