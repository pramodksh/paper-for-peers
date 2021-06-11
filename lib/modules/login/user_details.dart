import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/modules/dashboard/shared/loading_screen.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/services/image_picker/image_picker_service.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../config/default_assets.dart';
import '../../config/export_config.dart';
import 'user_course.dart';
import 'utilities.dart';
import 'utilities.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  ImagePickerService imagePickerService = ImagePickerService();
  var themeChange;

  double borderThickness = 5;
  double profileImageRadius = 90;

  File profilePhotoFile;
  TextEditingController userNameController = TextEditingController();

  bool _isLoading = false;

  Future<File> getImage({@required ImageSource imageSource}) async {
    setState(() { _isLoading = true; });
    File file = await imagePickerService.getPickedImageAsFile(imageSource: ImageSource.gallery);
    file = await imagePickerService.getCroppedImage(imageFile: file);
    setState(() { _isLoading = false; });
    return file;
  }

  Widget getCircularProfileImage() {
    Widget circleImage;
    if (profilePhotoFile == null) {
      circleImage = CircleAvatar(
        radius: profileImageRadius,
        backgroundColor: Colors.grey[800],
        child: Text(
          getUserNameForProfilePhoto(userNameController.text),
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      );
    } else {
      circleImage = CircleAvatar(
          radius: profileImageRadius,
          backgroundImage: FileImage(profilePhotoFile),
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

  Widget buildChooseSourceDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: themeChange.isDarkTheme ? CustomColors.reportDialogBackgroundColor : CustomColors.lightModeBottomNavBarColor,
      child: Container(
        // height: 400,
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
                      File _pickedFile = await getImage(imageSource: ImageSource.camera);
                      setState(() {
                        profilePhotoFile = _pickedFile;
                      });
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
                      File _pickedFile = await getImage(imageSource: ImageSource.gallery);
                      setState(() {
                        profilePhotoFile = _pickedFile;
                      });
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(CustomColors.bottomNavBarColor)
                    ),
                    child: Text("Gallery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                  ElevatedButton(
                    onPressed: profilePhotoFile == null ? null : () async {
                      setState(() {
                        profilePhotoFile = null;
                      });
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(
                          profilePhotoFile == null ? Colors.black54 : CustomColors.bottomNavBarColor
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    });
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
          ) : SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Stack(
                    children: [
                     getCircularProfileImage(),
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
                                  builder: (context) => buildChooseSourceDialog(),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Enter your Name',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 70),
                      child: getCustomTextField(
                        onChanged: (val) {
                          setState(() { });
                        },
                        hintText: "Name",
                        controller: userNameController,
                      )
                  ),
                  SizedBox(height: 100,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserCourse(),
                      ));
                    },
                    child: Text("Continue", style: TextStyle(fontSize: 18),),
                  ),
                  // getCustomButton(buttonText: 'Continue', onPressed: (){})
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
