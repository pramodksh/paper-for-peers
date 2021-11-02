import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/course_details.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/models/api_response.dart';
import 'package:papers_for_peers/models/user_model/user_model.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/modules/login/welcome_screen.dart';
import 'package:papers_for_peers/services/firebase_firestore/firebase_firestore_service.dart';

class UserCourse extends StatefulWidget {
  final UserModel user;

  UserCourse({this.user});

  @override
  _UserCourseState createState() => _UserCourseState();
}

class _UserCourseState extends State<UserCourse> {

  bool _isLoading = false;

  List<String> courses;
  List<String> semesters;

  String selectedCourse;
  String selectedSemester;

  String courseErrorText = "";
  String semesterErrorText = "";
  TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
  );

  @override
  void initState() {
    courses = getCourses().map((e) => e.courseName).toList();
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
          body: _isLoading ? LoadingScreen(
            loadingText: "Please wait...",
          ) : Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Select Course',style: TextStyle(fontSize: 30,),),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 200,
                      child: getCustomDropDown(
                          onDropDownTap: () { setState(() { courseErrorText = ""; }); },
                          isTransparent: true,
                          context: context,
                          dropDownValue: selectedCourse,
                          dropDownItems: courses,
                          dropDownHint: 'Courses',
                          onDropDownChanged: (val) {
                            setState(() {
                              selectedCourse = val;
                              Course course = getCourses().where((element) => element.courseName == selectedCourse).first;
                              semesters = course.semesters.map((e) => e.semester.toString()).toList();
                            });
                          }),
                    ),
                    SizedBox(height: 20,),
                    courseErrorText.isEmpty ? Container() : Text(courseErrorText, style: errorTextStyle,),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Select Semester',
                      style: TextStyle(
                        fontSize: 30,
                        color: selectedCourse == null ? Colors.grey : Colors.white,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: selectedCourse == null ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 180,
                      child: getCustomDropDown(
                          onDropDownTap: () { setState(() { semesterErrorText = ""; }); },
                          isTransparent: true,
                          context: context,
                          dropDownValue: selectedSemester,
                          dropDownItems: semesters,
                          dropDownHint: 'Semester',
                          onDropDownChanged: selectedCourse == null ? null : (val) {
                            setState(() {
                              selectedSemester = val;
                            });
                          }
                        ),
                    ),
                    SizedBox(height: 20,),
                    semesterErrorText.isEmpty ? Container() : Text(semesterErrorText, style: errorTextStyle,),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                  onPressed: () async {
                    if (selectedCourse == null) {
                      setState(() {
                        courseErrorText = "Please select course";
                      });
                    } else if (selectedSemester == null) {
                      setState(() {
                        semesterErrorText = "Please select semester";
                      });
                    } else {
                      if (mounted) {
                        setState(() { _isLoading = true; });
                      }
                      ApiResponse response = await FirebaseFireStoreService().addUser(user: UserModel(
                        uid: widget.user.uid,
                        displayName: widget.user.displayName,
                        photoUrl: widget.user.photoUrl,
                        email: widget.user.email,
                        course: selectedCourse,
                        semester: int.parse(selectedSemester),
                      ));
                      if (mounted) {
                        setState(() { _isLoading = false; });
                      }
                      if (response.isError) {
                        showAlertDialog(context: context, text: response.errorMessage);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IntroScreen(),
                        ));
                      }
                    }
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
