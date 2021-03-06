import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:provider/provider.dart';

class YourPosts extends StatefulWidget {
  @override
  _YourPostsState createState() => _YourPostsState();
}

class _YourPostsState extends State<YourPosts> with TickerProviderStateMixin {

  TabController? _tabController;
  double tabBarViewPadding = 10;

  Widget _getCommonTile({
    required bool isDarkTheme,
    String? label,
    String? subLabel,
    required int nDownloads,
    required onDeletePressed,
    required int nSemester,
  }) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
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
                    color: appThemeType.isDarkTheme() ? Colors.white60 : Colors.black54,
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

  Widget _getQuestionPapers({required bool isDarkTheme}) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          isDarkTheme: isDarkTheme,
          label: (index + 2000).toString(),
          nDownloads: 24,
          nSemester: 3,
          onDeletePressed: () {},
        );
      }),
    );
  }

  Widget _getNotesDetailsTile({
    required String title,
    required String description,
    required double rating,
    required onTileTap,
    required BuildContext context,
    required AppThemeType appThemeType,
    String? uploadedBy,
    DateTime? uploadedOn,
    bool isYourPostTile = false,
    Function()? yourPostTileOnEdit,
    Function()? yourPostTileOnDelete,
  }) {
    DateFormat dateFormat = DateFormat("dd MMMM yyyy");

    double ratingHeight = 30;
    double ratingWidth = 100;
    double ratingBorderRadius = 20;

    return GestureDetector(
      onTap: onTileTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                padding: EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: appThemeType.isDarkTheme() ? CustomColors.ratingBackgroundColor : CustomColors.lightModeRatingBackgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(ratingBorderRadius), topRight: Radius.circular(ratingBorderRadius)),
                ),
                height: 50,
                width: ratingWidth,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(rating.toString(), style: TextStyle(fontWeight: FontWeight.w600),),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              right: 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.only(top: ratingHeight),
              decoration: BoxDecoration(
                  color: appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              // height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Text(title, style: TextStyle(fontSize: 28,),),
                        SizedBox(height: 10,),
                        Text(description, style: TextStyle(fontSize: 16,),),
                        SizedBox(height: 10,),
                        isYourPostTile ? Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20))
                              ),
                              onPressed: yourPostTileOnEdit,
                              child: Text("Edit", style: TextStyle(fontSize: 16),),
                            ),
                            SizedBox(width: 10,),
                            ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20))
                              ),
                              onPressed: yourPostTileOnDelete,
                              child: Text("Delete", style: TextStyle(fontSize: 16),),
                            ),
                          ],
                        ) : Row(
                          children: [
                            // CircleAvatar(
                            //   child: FlutterLogo(),
                            //   radius: 20,
                            // ),
                            SizedBox(width: 10,),
                            Text(uploadedBy!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Text(dateFormat.format(uploadedOn!)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _getNotes({required bool isDarkTheme, required AppThemeType appThemeType}) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getNotesDetailsTile(
          appThemeType: appThemeType,
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

  Widget _getJournal({required bool isDarkTheme}) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          isDarkTheme: isDarkTheme,
          label: "CPP",
          nDownloads: 24,
          nSemester: 3,
          onDeletePressed: () {},
        );
      }),
    );
  }

  Widget _getSyllabusCopy({required bool isDarkTheme}) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          isDarkTheme: isDarkTheme,
          nDownloads: 24,
          nSemester: 3,
          onDeletePressed: () {},
        );
      }),
    );
  }

  Widget _getTextBooks({required bool isDarkTheme}) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: tabBarViewPadding),
      children: List.generate(10, (index) {
        return _getCommonTile(
          isDarkTheme: isDarkTheme,
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

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    Color selectedIconColor;
    Color unselectedIconColor;

    if (appThemeType.isDarkTheme()) {
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
                indicatorColor: appThemeType.isDarkTheme() ? CustomColors.lightModeBottomNavBarColor : CustomColors.bottomNavBarColor,
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
                  _getQuestionPapers(isDarkTheme: appThemeType.isDarkTheme()),
                  _getNotes(isDarkTheme: appThemeType.isDarkTheme(), appThemeType: appThemeType),
                  _getJournal(isDarkTheme: appThemeType.isDarkTheme()),
                  _getSyllabusCopy(isDarkTheme: appThemeType.isDarkTheme()),
                  _getTextBooks(isDarkTheme: appThemeType.isDarkTheme()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
