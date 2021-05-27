import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double profileImageRadius = 90;
  double borderThickness = 5;

  double statCircleRadius = 50;
  double statCircleBorderThickness = 4;

  String avgRating = '4.5';

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
        backgroundColor: CustomColors.backGroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('$title',
                textAlign: TextAlign.center,
                style: CustomTextStyle.bodyTextStyle.copyWith(
                    fontSize: 13,
                    color: CustomColors.bottomNavBarUnselectedIconColor)
                // TextStyle(
                //   fontSize: 12,
                // ),
                ),
            Text(
              '$value',
              style: CustomTextStyle.bodyTextStyle.copyWith(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Widget getCustomButton({@required String title}){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: CustomColors.bottomNavBarColor,
          shape: new RoundedRectangleBorder(
            side: BorderSide(
                color: CustomColors.bottomNavBarUnselectedIconColor,
                width: 2),
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          '$title',
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(DefaultAssets.leftArrowIcon),
      ),
      body: Column(
        children: [
          getCircularProfileImage(imagePath: DefaultAssets.profileImagePath),
          SizedBox(
            height: 30,
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
              getCircularStat(title: 'Average\nRating', value: '4.5'),
              getCircularStat(title: 'Total\nRating', value: '24'),
            ],
          ),
          SizedBox(height: 60,),
          getCustomButton(title: 'Your Post'),
          SizedBox(height: 30,),
          getCustomButton(title: 'Upload'),
        ],
      ),
    );
  }
}
