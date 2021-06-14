import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/modules/dashboard/main_dashboard.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';
// import 'package:papers_for_peers/modules/login/welcom_screen.dart';
import 'package:papers_for_peers/modules/login/welcome_screen.dart';

class UserCourse extends StatefulWidget {
  @override
  _UserCourseState createState() => _UserCourseState();
}

class _UserCourseState extends State<UserCourse> {

  List<String> courses = [
    "BCA",
    "BBA",
    "BCOM",
  ];
  List<String> semesters;


  String selectedCourse;
  String selectedSemester;

  @override
  void initState() {
    semesters = List.generate(6, (index) => "Semester - ${index + 1}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(DefaultAssets.appBackgroundPath),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Select Course',style: TextStyle(fontSize: 30),),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 200,
                      child: getCustomDropDown(
                          isTransparent: true,
                          context: context,
                          dropDownValue: selectedCourse,
                          dropDownItems: courses,
                          dropDownHint: 'Courses',
                          onDropDownChanged: (val) {
                            setState(() {
                              selectedCourse = val;
                            });
                          }),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Select Semester',style: TextStyle(fontSize: 30),),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 200,
                      child: getCustomDropDown(
                          isTransparent: true,
                          context: context,
                          dropDownValue: selectedSemester,
                          dropDownItems: semesters,
                          dropDownHint: 'Semester',
                          onDropDownChanged: (val) {
                            setState(() {
                              selectedSemester = val;
                            });
                          }),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => IntroScreen(),
                    ));
                  },
                  child: Text("Continue", style: TextStyle(fontSize: 18),),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
