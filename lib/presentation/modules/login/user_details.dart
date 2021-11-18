import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/api_response.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/services/firebase_firestore/firebase_firestore_service.dart';
import 'package:papers_for_peers/services/firebase_storage/firebase_storage_service.dart';
import 'package:papers_for_peers/services/image_picker/image_picker_service.dart';
import 'package:provider/provider.dart';

import 'user_course.dart';
import 'utilities.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double borderThickness = 5;
  double profileImageRadius = 90;

  Widget getCircularProfileImage({required File? photoFile, required String? userName}) {
    Widget circleImage;
    if (photoFile == null) {
      circleImage = CircleAvatar(
        radius: profileImageRadius,
        backgroundColor: Colors.grey[800],
        child: Text(
          getUserNameForProfilePhoto(userName ?? ""),
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

  Widget buildChooseSourceDialog({required bool isDarkTheme, required BuildContext context}) {

    UserState userState = context.select((UserCubit cubit) => cubit.state);

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
                      if (userState is UserEditSuccess) {
                        context.read<UserCubit>().pickImage(imageSource: ImageSource.camera,);
                      }
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.bottomNavBarColor)
                    ),
                    child: Text("Camera", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (userState is UserEditSuccess) {
                        context.read<UserCubit>().pickImage(imageSource: ImageSource.gallery,);
                      }
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.bottomNavBarColor)
                    ),
                    child: Text("Gallery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                  Builder(
                    builder: (context) {
                      if (userState is UserEditSuccess) {
                        return ElevatedButton(
                          onPressed: userState.profilePhotoFile == null ? null : () async {
                            context.read<UserCubit>().editUserRemoveProfilePhoto();
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                              backgroundColor: MaterialStateProperty.all(
                                  userState.profilePhotoFile == null ? Colors.black54 : CustomColors.bottomNavBarColor
                              )
                          ),
                          child: Text("Remove", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                        );
                      }
                      return Container();
                    }
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

  Widget _buildProfilePhotoEmptyDialog({required bool isDarkTheme}) {
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
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
      ),
    );
  }


  // todo
  Future<String?> _uploadPhotoAndGetUrl({required BuildContext context}) async {
    // print("UPLOAD PHOTO| ${widget.user!.photoUrl}");
    // if (mounted) {
    //   setState(() { _isLoading = true; _loadingText = "Uploading Photo"; });
    // }
    // ApiResponse response = await context.read<UserCubit>().uploadProfilePhotoToStorage(file: profilePhotoFile!, user: widget.user!);
    // if (mounted) {
    //   setState(() { _isLoading = false; });
    // }
    // if (response.isError) {
    //   showAlertDialog(context: context, text: response.errorMessage);
    //   return null;
    // } else {
    //   String? url = response.data;
    //   print("photo uploaded | $url");
    //   return url;
    // }
  }

  // todo
  Future _addUser({required BuildContext context}) async {
    // if (mounted) {
    //   setState(() { _isLoading = true; _loadingText = "Adding user"; });
    // }
    // ApiResponse response = await context.read<UserCubit>().addUser(widget.user!);
    // if (mounted) {
    //   setState(() { _isLoading = false; });
    // }
    // if (response.isError) {
    //   showAlertDialog(context: context, text: response.errorMessage);
    // } else {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (context) => UserCourse(user: widget.user,),
    //   ));
    // }
  }

  @override
  void initState() {

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      UserState userState = context.read<UserCubit>().state;
      if (userState is! UserEditSuccess) {
        context.read<UserCubit>().initiateUserEdit();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

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
          body: Builder(
            builder: (context) {

              UserState userState = context.watch<UserCubit>().state;

              // todo remove
              print("USER STATE IN USER DETAILS: ${userState}");

              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Builder(
                        builder: (context) {

                          if (userState is UserEditSuccess) {
                            return Stack(
                              children: [
                                getCircularProfileImage(
                                  photoFile: userState.profilePhotoFile,
                                  userName: userState.userModel.displayName,
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
                                            builder: (context) => buildChooseSourceDialog(
                                              isDarkTheme: appThemeType.isDarkTheme(),
                                              context: context,
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            );
                          } else if (userState is UserEditLoading) {
                            return Container(
                              height: 100,
                              child: Center(child: CircularProgressIndicator.adaptive()),
                            );
                          } else {
                            return Container();
                          }

                        },
                      ),
                      SizedBox(height: 80,),
                      Text('Enter your Name', style: TextStyle(fontSize: 30),),
                      SizedBox(height: 30,),
                      Form(
                        key: _formKey,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 70),
                            child: getCustomTextField(
                              onChanged: (val) {
                                if (userState is UserEditSuccess) {
                                  context.read<UserCubit>().editUser(
                                    userModel: userState.userModel.copyWith(displayName: val),
                                  );
                                }
                              },
                              hintText: "Name",
                              validator: (String? val) => val!.isEmpty ? "Enter your name" : null,
                            )
                        ),
                      ),
                      SizedBox(height: 100,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                        onPressed: () async {

                          // todo
                          if (_formKey.currentState!.validate()) {
                            UserState userState = context.read<UserCubit>().state;

                            if (userState is UserEditSuccess) {
                              print("NAME: ${userState.userModel.displayName}");

                              if (userState.profilePhotoFile == null) {
                                bool? isDisplayChooseSourceDialog = await showDialog(
                                  context: context,
                                  builder: (context) => _buildProfilePhotoEmptyDialog(isDarkTheme: appThemeType.isDarkTheme()),
                                );

                                if (isDisplayChooseSourceDialog == true) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => buildChooseSourceDialog(
                                      isDarkTheme: appThemeType.isDarkTheme(),
                                      context: context,
                                    ),
                                  );
                                } else if (isDisplayChooseSourceDialog == false) {
                                  // context.read<UserCubit>().addUser(); //todo
                                }

                              } else {

                              }

                            }

                          }


                          // if (_formKey.currentState!.validate()) {
                          //
                          //   widget.user!.displayName = userNameController.text;
                          //
                          //   if (profilePhotoFile == null) {
                          //     bool? shouldDisplayDismissibleDialog = await showDialog(
                          //       context: context,
                          //       builder: (context) => _buildProfilePhotoEmptyDialog(isDarkTheme: appThemeType.isDarkTheme()),
                          //     );
                          //     if (shouldDisplayDismissibleDialog == true) {
                          //       showDialog(
                          //         context: context,
                          //         builder: (context) => buildChooseSourceDialog(isDarkTheme: appThemeType.isDarkTheme()),
                          //       );
                          //     } else if(shouldDisplayDismissibleDialog == false) {
                          //       widget.user!.photoUrl = "";
                          //       await _addUser(context: context);
                          //     }
                          //   } else {
                          //     String? url = await _uploadPhotoAndGetUrl(context: context);
                          //     widget.user!.photoUrl = url;
                          //     await _addUser(context: context);
                          //   }
                          // }
                        },
                        child: Text("Continue", style: TextStyle(fontSize: 18),),
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
  }
}
