import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

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
  var themeChange;

  Widget getCircularProfileImage({@required imagePath}) {
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
      child: CircleAvatar(
        radius: profileImageRadius,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }

  Widget getCircularStat({@required String title, @required String value}) {
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
        backgroundColor: themeChange.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeRatingBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTextStyle.bodyTextStyle.copyWith(
                fontSize: 13,
                color: themeChange.isDarkTheme ? Colors.white : Colors.black,
              )
            ),
            SizedBox(height: 5,),
            Text(
              value,
              style: CustomTextStyle.bodyTextStyle.copyWith(
                fontSize: 20,
                color: themeChange.isDarkTheme ?  Colors.white70 : Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCustomButton({@required String title, @required Function onPressed}){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: themeChange.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeRatingBackgroundColor,
          shape: new RoundedRectangleBorder(
            side: BorderSide(
                color: themeChange.isDarkTheme ? CustomColors.bottomNavBarUnselectedIconColor : Colors.black,
                width: 2),
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 20, color: themeChange.isDarkTheme ? Colors.white : Colors.black),
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

    themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
        centerTitle: true,
      ),
      body: themeChange == null ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              getCircularProfileImage(imagePath: DefaultAssets.profileImagePath),
              SizedBox(
                height: 20,
              ),
              Text(
                'John Doe',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getCircularStat(title: 'Average\nRating', value: avgRating.toString()),
                  getCircularStat(title: 'Total\nRating', value: totalDownloads.toString()),
                ],
              ),
              SizedBox(height: 30,),
              getCustomButton(title: 'Your Post', onPressed: () {}),
              SizedBox(height: 30,),
              getCustomButton(title: 'Upload', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
