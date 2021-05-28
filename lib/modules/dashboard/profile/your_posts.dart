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

class _YourPostsState extends State<YourPosts> {

  int selectedItemPosition = 0;


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
              padding: EdgeInsets.symmetric(vertical: 20,),
              child: Row(
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
              ),
              // height: 100,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: List.generate(10, (index) {
                    if (selectedItemPosition == 1) {
                      return getNotesDetailsTile(
                        isYourPostTile: true,
                        context: context,
                        onTileTap: () {},
                        title: "Title Title Title",
                        description: "Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
                        rating: 3.5,
                      );
                    } else {
                      return Text("hi");
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
