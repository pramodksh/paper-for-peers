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

  TabController _tabController;
  double tabBarViewPadding = 10;

  Widget _getCommonTile({
    String label,
    String subLabel,
    @required int nDownloads,
    @required onDeletePressed,
    @required int nSemester,
  }) {
    var themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: themeChange.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          label != null && subLabel != null
            ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(label, style: TextStyle(fontSize: 28,),),
                SizedBox(height: 8,),
                Text(
                  subLabel,
                  style: TextStyle(
                    fontSize: 16,
                    color: themeChange.isDarkTheme ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ) : label != null ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 28,),),
              Text("Downloads: $nDownloads", style: TextStyle(fontSize: 16,),),
            ],
          ) : Text("Downloads: $nDownloads", style: TextStyle(fontSize: 16,),),
          SizedBox(height: 10,),
          Text("Semester: $nSemester", style: TextStyle(fontSize: 16,),),
          SizedBox(height: 10,),
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20))
                ),
                onPressed: onDeletePressed,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 8,),
                    Text("Delete", style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getQuestionPapers() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          label: (index + 2000).toString(),
          nDownloads: 24,
          nSemester: 3,
          onDeletePressed: () {},
        );
      }),
    );
  }

  Widget _getNotes() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return getNotesDetailsTile(
          isYourPostTile: true,
          yourPostTileOnDelete: () {},
          yourPostTileOnEdit: () {},
          context: context,
          onTileTap: () {},
          title: "Title Title Title",
          description: "Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
          rating: 3.5,
        );
      }),
    );
  }

  Widget _getJournal() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          label: "CPP",
          nDownloads: 24,
          nSemester: 3,
          onDeletePressed: () {},
        );
      }),
    );
  }

  Widget _getSyllabusCopy() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          nDownloads: 24,
          nSemester: 3,
          onDeletePressed: () {},
        );
      }),
    );
  }

  Widget _getTextBooks() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          label: "Learn CPP in 20 days with Advanced OOPS",
          subLabel: "Author",
          nDownloads: 24,
          nSemester: 3,
          onDeletePressed: () {},
        );
      }),
    );
  }

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
                  ),
                )
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _getQuestionPapers(),
                  _getNotes(),
                  _getJournal(),
                  _getSyllabusCopy(),
                  _getTextBooks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
