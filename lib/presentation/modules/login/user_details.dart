import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';


class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double borderThickness = 5;
  double profileImageRadius = 90;

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

  Widget _buildChooseSourceDialog({required bool isDarkTheme, required BuildContext context}) {

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

  Widget _buildIsUserWantsToUploadPhoto({required bool isDarkTheme}) {
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
  void initState() {

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      UserState userState = context.read<UserCubit>().state;
      if (userState is! UserEditSuccess) {
        context.read<UserCubit>().initiateUserEdit();
      }
    });

    super.initState();
  }

  Widget getProfilePhotoWidget({
    required File? photoFile,
    required String? userName,
    required bool isDarkTheme
  }) {
    return Stack(
      children: [
        _getCircularProfileImage(
          photoFile: photoFile,
          userName: userName,
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
                    builder: (context) => _buildChooseSourceDialog(
                      isDarkTheme: isDarkTheme,
                      context: context,
                    ),
                  );
                }),
          ),
        ),
      ],
    );
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
        BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserEditError) {
              Utils.showAlertDialog(context: context, text: state.errorMessage);
            } else if (state is UserAddError) {
              Utils.showAlertDialog(context: context, text: state.errorMessage);
            }

            // if user state is changed from user edit
            // to user loaded then reload the stream of user
            if (state is UserLoaded) {
              context.read<UserCubit>().reloadUser();
            }

          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
              builder: (context) {
                UserState userState = context.watch<UserCubit>().state;

                if (userState is UserLoading) {
                  return LoadingScreen(loadingText: "Adding user",);
                }

                return SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: 100,),
                        Builder(
                          builder: (context) {

                            if (userState is UserEditSuccess) {
                              return getProfilePhotoWidget(
                                isDarkTheme: appThemeType.isDarkTheme(),
                                userName: userState.userModel.displayName,
                                photoFile: userState.profilePhotoFile,
                              );
                            } else if (userState is UserEditProfilePhotoLoading) {
                              return Container(
                                height: 100,
                                child: Center(child: CircularProgressIndicator.adaptive()),
                              );
                            } else if (userState is UserEditSubmitting) {
                              return getProfilePhotoWidget(
                                isDarkTheme: appThemeType.isDarkTheme(),
                                userName: userState.userModel.displayName,
                                photoFile: userState.profilePhotoFile,
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
                              child: Utils.getCustomTextField(
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
                        Builder(
                          builder: (context) {
                            if (userState is UserEditSubmitting) {
                              return Center(child: CircularProgressIndicator.adaptive(),);
                            } else if (userState is UserEditSuccess) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    UserState userState = context.read<UserCubit>().state;

                                    if (userState is UserEditSuccess) {

                                      if (userState.profilePhotoFile == null) {
                                        bool? isUserWantsToUploadPhoto = await showDialog(
                                          context: context,
                                          builder: (context) => _buildIsUserWantsToUploadPhoto(isDarkTheme: appThemeType.isDarkTheme()),
                                        );

                                        if (isUserWantsToUploadPhoto == true) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => _buildChooseSourceDialog(
                                              isDarkTheme: appThemeType.isDarkTheme(),
                                              context: context,
                                            ),
                                          );
                                        } else if (isUserWantsToUploadPhoto == false) {
                                          await context.read<UserCubit>().addUser(userState.userModel);

                                        }

                                      } else {
                                        context.read<UserCubit>().uploadProfilePhotoToStorage(
                                          file: userState.profilePhotoFile!,
                                          user: userState.userModel,
                                        );
                                        await context.read<UserCubit>().addUser(userState.userModel);
                                      }
                                    }
                                  }
                                },
                                child: Text("Continue", style: TextStyle(fontSize: 18),),
                              );
                            } else {
                              return Container();
                            }
                          }
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        )
      ],
    );
  }
}
