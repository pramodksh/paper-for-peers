import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/course.dart';
import 'package:papers_for_peers/data/models/semester.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/sign_up/sign_up_cubit.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final double borderThickness = 5;
  final double profileImageRadius = 90;

  Widget _getCircularProfileImage({required File? photoFile, required String? userName}) {
    Widget circleImage;
    if (photoFile == null) {
      circleImage = CircleAvatar(
        radius: profileImageRadius,
        backgroundColor: Colors.grey[800],
        child: Text(
          Utils.getUserNameForProfilePhoto(userName ?? ""),
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      );
    } else {
      circleImage = CircleAvatar(
        radius: profileImageRadius,
        backgroundImage: FileImage(photoFile),
      );
    }

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
      child: circleImage,
    );
  }

  Widget _buildChooseSourceDialog({required bool isDarkTheme, required BuildContext context, required bool isDisplayRemoveButton}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: isDarkTheme ? CustomColors.reportDialogBackgroundColor : CustomColors.lightModeBottomNavBarColor,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Text("Choose", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xff373F41), fontStyle: FontStyle.italic),),
              SizedBox(height: 10,),
              ListView(
                shrinkWrap: true,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      context.read<SignUpCubit>().pickImage(imageSource: ImageSource.camera);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.bottomNavBarColor)
                    ),
                    child: Text("Camera", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      context.read<SignUpCubit>().pickImage(imageSource: ImageSource.gallery);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.bottomNavBarColor)
                    ),
                    child: Text("Gallery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                  ElevatedButton(
                    onPressed: isDisplayRemoveButton ? () {
                      Navigator.of(context).pop();
                      context.read<SignUpCubit>().removeUserPhoto();
                    } : null,
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(isDisplayRemoveButton ? CustomColors.bottomNavBarColor :  Colors.black54,
                        )
                    ),
                    child: Text("Remove", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Text(
                "Caution: You cannot change the profile once you tap on continue",
                style: TextStyle(color: Colors.black54,),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),
            ]
        ),
      ),
    );
  }


  Widget _getProfilePhotoWidget({
    required SignUpState signUpState,
    required bool isDarkTheme,
    required BuildContext context,
  }) {
    return Stack(
      children: [
        _getCircularProfileImage(
          photoFile: signUpState.profilePhotoFile,
          userName: signUpState.username,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: CustomColors.bottomNavBarColor,
                shape: BoxShape.circle),
            child: IconButton(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _buildChooseSourceDialog(
                      isDarkTheme: isDarkTheme,
                      context: context,
                      isDisplayRemoveButton: signUpState.profilePhotoFile != null,
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget _buildIsUserWantsToUploadPhoto({required bool isDarkTheme, required BuildContext context}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: isDarkTheme ? CustomColors.reportDialogBackgroundColor : CustomColors.lightModeBottomNavBarColor,
      child: Container(
        // height: 400,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Text("Are you sure you don't want to upload your Profile Photo?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xff373F41), fontStyle: FontStyle.italic,), textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              Text("Note: You cannot edit it once you tap on continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff373F41),), textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black26),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.lightModeBottomNavBarColor)
                    ),
                    child: Text("Yes, I'm sure", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black26),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.bottomNavBarColor)
                    ),
                    child: Text("No", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final SignUpState signUpState = context.watch<SignUpCubit>().state;


    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.signUpDemoStateStatus.isError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage!);
          context.read<SignUpCubit>().resetErrorToSuccess();
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(55, 70, 55, 30),
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    DefaultAssets.mainLogoPath,
                    height: 110,
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(height: 20,),
                Utils.getCustomTextField(
                  labelText: 'Email Address',
                  onChanged: (val) {
                    context.read<SignUpCubit>().emailChanged(val);
                  },
                  validator: (String? val) => context.read<SignUpCubit>().isEmailValid(val!) ? null : "Please enter valid email",
                ),
                SizedBox(height: 20,),
                Utils.getCustomPasswordField(
                  inputBoxText: 'Password',
                  onChanged: (val) {
                    context.read<SignUpCubit>().passwordChanged(val);
                  },
                  obscureText: signUpState.isPasswordObscure,
                  onTapObscure: () { context.read<SignUpCubit>().passwordObscureToggle(); },
                  validator: (String? val) => context.read<SignUpCubit>().isPasswordValid(val!) ? null : "Enter Password",
                ),
                SizedBox(height: 20,),
                Utils.getCustomPasswordField(
                  inputBoxText: 'Confirm Password',
                  onChanged: (val) {
                    context.read<SignUpCubit>().confirmPasswordChanged(val);
                  },
                  obscureText: signUpState.isConfirmPasswordObscure,
                  onTapObscure: () { context.read<SignUpCubit>().confirmPasswordObscureToggle(); },
                  validator: (String? val) => context.read<SignUpCubit>().isConfirmPasswordValid(val!) ? null : "Passwords do not match",
                ),
                SizedBox(height: 50,),
                Text("User Details:", style: TextStyle(fontSize: 20),),
                SizedBox(height: 30,),
                Center(
                  child: _getProfilePhotoWidget(
                    signUpState: signUpState,
                    context: context,
                    isDarkTheme: appThemeType.isDarkTheme(),
                  ),
                ),
                SizedBox(height: 30,),
                Utils.getCustomTextField(
                  onChanged: (val) {
                    context.read<SignUpCubit>().usernameChanged(val);
                  },
                  hintText: "User Name",
                  validator: (String? val) => context.read<SignUpCubit>().isUsernameValid(val!) ? null : "Enter your name",
                ),

                SizedBox(height: 50,),
                Text("Course Details:", style: TextStyle(fontSize: 20),),
                SizedBox(height: 30,),

                Center(
                  child: Builder(
                      builder: (context) {

                        if (signUpState.isCoursesLoading) {
                          return Center(child: CircularProgressIndicator.adaptive(),);
                        } else {
                          List<Course> courses = signUpState.courses!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('Select Course',style: TextStyle(fontSize: 24,),),
                                  SizedBox(height: 20,),

                                  SizedBox(
                                    width: 200,
                                    child: Utils.getCustomDropDown<Course>(
                                      isTransparent: true,
                                      context: context,
                                      dropDownValue: signUpState.selectedCourse,
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
                                        context.read<SignUpCubit>().courseChanged(val!);
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 30,),

                              Column(
                                children: [
                                  Text(
                                    'Select Semester',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: signUpState.selectedCourse == null ? Colors.grey : Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Builder(
                                      builder: (context) {
                                        // if (signUpState.selectedCourse != null) {
                                          List<Semester>? semesters = signUpState.selectedCourse == null ? [] : signUpState.selectedCourse!.semesters;
                                          return SizedBox(
                                            width: 200,
                                            child: Utils.getCustomDropDown<Semester>(
                                              isTransparent: true,
                                              context: context,
                                              dropDownValue: signUpState.selectedSemester,
                                              dropDownItems: semesters,
                                              dropDownHint: 'Semester',
                                              onDropDownChanged: signUpState.selectedCourse == null ? null : (val) {
                                                context.read<SignUpCubit>().semesterChanged(val!);
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
                                        // }
                                      }
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ],
                          );
                        }
                      }
                  ),
                ),

                SizedBox(height: 40,),

                SizedBox(
                  width: 350,
                  height: 50,
                  child: signUpState.signUpDemoStateStatus.isLoading
                      ? Center(child: CircularProgressIndicator.adaptive())
                      : Utils.getCustomButton(
                    buttonText: 'Sign Up',
                    onPressed: () async {
                      if (_formKey.currentState!.validate())  {

                        if (signUpState.profilePhotoFile == null) {
                          bool? isUserWantsToUploadPhoto = await showDialog(
                            context: context,
                            builder: (context) => _buildIsUserWantsToUploadPhoto(isDarkTheme: appThemeType.isDarkTheme(), context: context),
                          );

                          if (isUserWantsToUploadPhoto == true) {
                            showDialog(
                              context: context,
                              builder: (_) => _buildChooseSourceDialog(
                                isDarkTheme: appThemeType.isDarkTheme(),
                                context: context,
                                isDisplayRemoveButton: signUpState.profilePhotoFile != null,
                              ),
                            );
                          }
                        }

                        context.read<SignUpCubit>().buttonClicked();
                      }
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
