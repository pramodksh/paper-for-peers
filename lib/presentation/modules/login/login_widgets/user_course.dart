import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class UserCourse extends StatefulWidget {

  final UserModel userModel;

  UserCourse({required this.userModel});

  @override
  _UserCourseState createState() => _UserCourseState();
}

class _UserCourseState extends State<UserCourse> {

  final TextStyle errorTextStyle = TextStyle(fontSize: 14,);

  Course? selectedCourse;
  Semester? selectedSemester;

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final FirestoreRepository firestoreRepository = context.select((FirestoreRepository repo) => repo);

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
              child: FutureBuilder(
                future: firestoreRepository.getCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen(loadingText: "Loading...",);
                  } else {
                    return StatefulBuilder(
                        builder: (context, setBuilderState) {
                          List<Course> courses = snapshot.data as List<Course>;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('Select Course',style: TextStyle(fontSize: 30,),),
                                  SizedBox(height: 20,),

                                  SizedBox(
                                    width: 200,
                                    child: Utils.getCustomDropDown<Course>(
                                      isTransparent: true,
                                      context: context,
                                      dropDownValue: selectedCourse,
                                      dropDownItems: courses,
                                      dropDownHint: 'Courses',
                                      items: courses.map((Course value) {
                                        return DropdownMenuItem<Course>(
                                          value: value,
                                          child: Text(value.courseName!, style: CustomTextStyle.bodyTextStyle.copyWith(
                                            fontSize: 18,
                                            color: appThemeType.isDarkTheme() ? Colors.white60 : Colors.black,
                                          ),),
                                        );
                                      }).toList(),
                                      onDropDownChanged: (val) {
                                        setBuilderState(() { selectedCourse = val; });
                                      },
                                    ),
                                  ),
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
                                  Builder(
                                      builder: (context) {

                                        List<Semester>? semesters = selectedCourse == null ? [] : selectedCourse!.semesters;

                                        return SizedBox(
                                          width: 200,
                                          child: Utils.getCustomDropDown<Semester>(
                                            isTransparent: true,
                                            context: context,
                                            dropDownValue: selectedSemester,
                                            dropDownItems: semesters,
                                            dropDownHint: 'Semester',
                                            onDropDownChanged: selectedCourse == null ? null : (val) {
                                              setBuilderState(() { selectedSemester = val; });
                                            },
                                            items: semesters?.map((Semester value) {
                                              return DropdownMenuItem<Semester>(
                                                value: value,
                                                child: Text(value.nSemester.toString(), style: CustomTextStyle.bodyTextStyle.copyWith(
                                                  fontSize: 18,
                                                  color: appThemeType.isDarkTheme() ? Colors.white60 : Colors.black,
                                                ),),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      }
                                  ),
                                  SizedBox(height: 20,),
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
                                  if (true) {
                                    if (selectedCourse == null) {
                                      Utils.showAlertDialog(context: context, text: "Please select course");
                                      return;
                                    }

                                    if (selectedSemester == null) {
                                      Utils.showAlertDialog(context: context, text: "Please select semester");
                                      return;
                                    }

                                    await context.read<FirestoreRepository>().addUser(user: widget.userModel.copyWith(
                                      course: selectedCourse,
                                      semester: selectedSemester,
                                    ));
                                    context.read<AuthRepository>().reloadCurrentUser();
                                  }

                                },
                                child: Text("Continue", style: TextStyle(fontSize: 18),),
                              ),
                            ],
                          );

                        }
                    );
                  }
                }
              ),
            ),
          )
        ],
      );
  }
}
