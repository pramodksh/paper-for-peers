import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/course_and_semester/course_and_semester_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/presentation/modules/login/welcome_screen.dart';
import 'package:papers_for_peers/services/firebase_firestore/firebase_firestore_service.dart';
import 'package:provider/provider.dart';

class UserCourse extends StatefulWidget {
  final UserModel? user;

  UserCourse({this.user});

  @override
  _UserCourseState createState() => _UserCourseState();
}

class _UserCourseState extends State<UserCourse> {

  bool _isLoading = false;

  Course? selectedCourse;
  Semester? selectedSemester;

  String courseErrorText = "";
  String semesterErrorText = "";
  TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    CourseAndSemesterState courseAndSemesterState = context.select((CourseAndSemesterCubit cubit) => cubit.state);

    if (courseAndSemesterState is CourseAndSemesterInitial) {
      context.read<CourseAndSemesterCubit>().fetchCourses();
    }

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
                Builder(
                  builder: (context) {

                    if (courseAndSemesterState is CourseAndSemesterLoading) {
                      return CircularProgressIndicator.adaptive();
                    } else if (courseAndSemesterState is CourseAndSemesterLoaded) {

                      List<Course> courses = courseAndSemesterState.courses;

                      return Column(
                        children: [
                          Text('Select Course',style: TextStyle(fontSize: 30,),),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: 200,
                            child: getCustomDropDown<Course>(
                              onDropDownTap: () { setState(() { courseErrorText = ""; }); },
                              isTransparent: true,
                              context: context,
                              dropDownValue: selectedCourse,
                              dropDownItems: courses,
                              dropDownHint: 'Courses',
                              items: courses.map((Course value) {
                                return DropdownMenuItem<Course>(
                                  value: value,
                                  child: Text(value.courseName.toUpperCase(), style: CustomTextStyle.bodyTextStyle.copyWith(
                                    fontSize: 18,
                                    color: appThemeType.isDarkTheme() ? Colors.white60 : Colors.black,
                                  ),),
                                );
                              }).toList(),
                              onDropDownChanged: (val) {
                                setState(() {
                                  if (mounted) setState(() {
                                    selectedCourse = val;
                                  });
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          courseErrorText.isEmpty ? Container() : Text(courseErrorText, style: errorTextStyle,),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator.adaptive();
                    }

                  }
                ),
                Builder(
                  builder: (context) {
                    List<Semester>? semesters = selectedCourse?.semesters;
                    return Column(
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
                          child: getCustomDropDown<Semester>(
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
                            },
                            items: semesters?.map((Semester value) {
                              return DropdownMenuItem<Semester>(
                                value: value,
                                child: Text(value.semester.toString(), style: CustomTextStyle.bodyTextStyle.copyWith(
                                  fontSize: 18,
                                  color: appThemeType.isDarkTheme() ? Colors.white60 : Colors.black,
                                ),),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20,),
                        semesterErrorText.isEmpty ? Container() : Text(semesterErrorText, style: errorTextStyle,),
                      ],
                    );
                  },
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
                        uid: widget.user!.uid,
                        displayName: widget.user!.displayName,
                        photoUrl: widget.user!.photoUrl,
                        email: widget.user!.email,
                        course: selectedCourse!.courseName,
                        semester: selectedSemester!.semester,
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
