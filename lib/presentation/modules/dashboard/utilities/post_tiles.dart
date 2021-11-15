import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:provider/provider.dart';

Widget getNotesDetailsTile({
  required String title,
  required String description,
  required double rating,
  required onTileTap,
  required BuildContext context,
  String? uploadedBy,
  DateTime? uploadedOn,
  bool isYourPostTile = false,
  Function()? yourPostTileOnEdit,
  Function()? yourPostTileOnDelete,
}) {
  DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

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
                          CircleAvatar(
                            child: FlutterLogo(),
                            radius: 20,
                          ),
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