import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/upload/upload_notes.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/upload/upload_question_paper.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/your_posts/your_posts.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

enum TypesOfPost {
  QuestionPaper,
  Notes,
  SyllabusCopy,
  Journal,
}


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double profileImageRadius = 90;
  double borderThickness = 5;

  double statCircleRadius = 50;
  double statCircleBorderThickness = 4;

  double avgRating = 4.5;
  int totalDownloads = 20;

  List<Map<String, dynamic>> typesOfPosts = [
    { "label": "Question Paper", "enum": TypesOfPost.QuestionPaper },
    { "label": "Notes", "enum": TypesOfPost.Notes },
    { "label": "Journal", "enum": TypesOfPost.Journal },
    { "label": "Syllabus Copy", "enum": TypesOfPost.SyllabusCopy },
  ];

  Widget _getCircularProfileImage({required String? url, required String username}) {
    return Container(
      padding: EdgeInsets.all(borderThickness),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          // stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Color(0xff6A0EB1),
            Color(0xff8C2196),
          ],
        ),
      ),
      child: url == null ? CircleAvatar(
        radius: profileImageRadius,
        child: Text(Utils.getUserNameForProfilePhoto(username), style: TextStyle(fontSize: 50),),
      ) : CachedNetworkImage(
        imageUrl: url,
        progressIndicatorBuilder: (context, url, progress) {
          return CircleAvatar(
            radius: profileImageRadius,
            child: Center(child: CircularProgressIndicator.adaptive(),),
          );
        },
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(
            radius: profileImageRadius,
            backgroundImage: imageProvider,
          );
        },
      ),
    );
  }

  Widget _getCircularStat({required String title, required String value, required bool isDarkTheme}) {
    return Container(
      padding: EdgeInsets.all(statCircleBorderThickness),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Color(0xff7000FF),
            Color(0xffF01D1D),
          ],
        ),
      ),
      child: CircleAvatar(
        radius: statCircleRadius,
        backgroundColor: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeRatingBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTextStyle.bodyTextStyle.copyWith(
                fontSize: 13,
                color: isDarkTheme ? Colors.white : Colors.black,
              )
            ),
            SizedBox(height: 5,),
            Text(
              value,
              style: CustomTextStyle.bodyTextStyle.copyWith(
                fontSize: 20,
                color: isDarkTheme ?  Colors.white70 : Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getProfileCustomButton({required String title, required Function() onPressed, required bool isDarkTheme}){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeRatingBackgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: isDarkTheme ? CustomColors.bottomNavBarUnselectedIconColor : Colors.black,
                width: 2),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildUploadDialog({required bool isDarkTheme}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: isDarkTheme ? CustomColors.reportDialogBackgroundColor : CustomColors.lightModeBottomNavBarColor,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15,),
            Text("Upload", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xff373F41), fontStyle: FontStyle.italic),),
            SizedBox(height: 10,),
            Column(
              children: typesOfPosts.map((e) => Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                // height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        TypesOfPost? selected = e["enum"];
                        if (selected == TypesOfPost.QuestionPaper) {
                          return UploadQuestionPaper();
                        } else {
                          return UploadNotesAndJournal(label: e["label"], typesOfPost: e["enum"],);
                        }
                      },
                    ));
                  },
                  child: Text(e["label"], style: TextStyle(fontSize: 20),),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final UserState userState = context.select((UserCubit cubit) => cubit.state);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
        centerTitle: true,
      ),
      body: Builder(
          builder: (context) {
            if (userState is UserLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getCircularProfileImage(url: userState.userModel.photoUrl, username: userState.userModel.displayName!),
                  SizedBox(height: 20,),
                  Text(userState.userModel.displayName!, style: TextStyle(fontSize: 25),),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _getCircularStat(title: 'Average\nRating', value: userState.userModel.avgRating!.toStringAsPrecision(3), isDarkTheme: appThemeType.isDarkTheme()),
                      _getCircularStat(title: 'Total\nRating', value: userState.userModel.totalRating.toString(), isDarkTheme: appThemeType.isDarkTheme()),
                    ],
                  ),
                ],
              );
            }
            return Container();
          }
      ),
    );
  }
}
