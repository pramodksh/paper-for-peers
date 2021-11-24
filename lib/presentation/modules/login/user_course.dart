import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/login/welcome_screen.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class UserCourse extends StatefulWidget {
  @override
  _UserCourseState createState() => _UserCourseState();
}

class _UserCourseState extends State<UserCourse> {

  final TextStyle errorTextStyle = TextStyle(fontSize: 14,);

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final FirestoreRepository firestoreRepository = context.select((FirestoreRepository repo) => repo);

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        }
      },
      child: Stack(
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

                    UserState userState = context.select((UserCubit cubit) => cubit.state);

                    if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                      return Center(child: CircularProgressIndicator.adaptive(),);
                    } else if (userState is UserLoaded) {
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
                                  dropDownValue: userState.userModel.course,
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
                                    context.read<UserCubit>().setUser(userState.userModel.copyWith(course: val),);
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
                                  color: userState is UserLoaded && userState.userModel.course == null
                                      ? Colors.grey : Colors.white,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Builder(
                                  builder: (context) {

                                    if (userState is UserLoaded) {

                                      List<Semester>? semesters = userState.userModel.course?.semesters;

                                      return SizedBox(
                                        width: 200,
                                        child: Utils.getCustomDropDown<Semester>(
                                          isTransparent: true,
                                          context: context,
                                          dropDownValue: userState.userModel.semester,
                                          dropDownItems: semesters,
                                          dropDownHint: 'Semester',
                                          onDropDownChanged: userState.userModel.course == null ? null : (val) {
                                            context.read<UserCubit>().setUser(userState.userModel.copyWith(semester: val));
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
                                    } else {
                                      return CircularProgressIndicator.adaptive();
                                    }
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
                              if (userState is UserLoaded) {
                                if (!userState.isValidCourse) {
                                  Utils.showAlertDialog(context: context, text: "Please select course");
                                  return;
                                }

                                if (!userState.isValidSemester) {
                                  Utils.showAlertDialog(context: context, text: "Please select semester");
                                  return;
                                }

                                print("ADD USER: ${userState.userModel}");


                                ApiResponse addUserResponse = await context.read<UserCubit>().addUser(userState.userModel);
                                if (!addUserResponse.isError) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => IntroScreen(),
                                  ));
                                }

                              }

                            },
                            child: Text("Continue", style: TextStyle(fontSize: 18),),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator.adaptive(),);
                    }
                  }
                ),
              ),
            )
          ],
        ),
    );
  }
}
