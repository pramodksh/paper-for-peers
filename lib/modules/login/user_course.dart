import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';

class UserCourse extends StatefulWidget {
  @override
  _UserCourseState createState() => _UserCourseState();
}

class _UserCourseState extends State<UserCourse> {

  // Widget getCustomRoundedButton({@required String semester}){
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: CustomColors.bottomNavBarColor,
  //         shape: BoxShape.circle),
  //     padding: EdgeInsets.all(1),
  //     child: TextButton(
  //       child: Text(semester,style: TextStyle(fontSize: 20,color: Colors.white),),
  //     ),
  //   );
  // }

  List<String> courses = [
    "BCA",
    "BBA",
    "BCOM",
  ];
  List<String> semesters = [
    '1','2','3','4','5','6'
  ];

  // String selectedSubject;

  String selectedCourse;
  String selectedSemester;
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text('Select Course',style: TextStyle(fontSize: 30),),
                  SizedBox(height: 50,),
                  getCustomDropDown(
                      context: context,
                      dropDownValue: selectedCourse,
                      dropDownItems: courses,
                      dropDownHint: 'Courses',
                      onDropDownChanged: (val) {
                        setState(() {
                          selectedCourse = val;
                        });
                      }),
                  SizedBox(height: 120,),
                  Text('Select Semester',style: TextStyle(fontSize: 30),),
                  SizedBox(height: 50,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     getCustomRoundedButton(semester: '1'),
                  //     getCustomRoundedButton(semester: '2'),
                  //     getCustomRoundedButton(semester: '3'),
                  //     getCustomRoundedButton(semester: '4'),
                  //     getCustomRoundedButton(semester: '5'),
                  //     getCustomRoundedButton(semester: '6'),
                  //   ],
                  // ),
                  getCustomDropDown(
                      context: context,
                      dropDownValue: selectedSemester,
                      dropDownItems: semesters,
                      dropDownHint: 'Semester',
                      onDropDownChanged: (val) {
                        setState(() {
                          selectedSemester = val;
                        });
                      }),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
