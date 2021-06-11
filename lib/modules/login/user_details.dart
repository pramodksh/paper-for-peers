import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/services/image_picker/image_picker_service.dart';

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


  double borderThickness = 5;
  double profileImageRadius = 90;

  File profilePhotoFile;
  TextEditingController userNameController = TextEditingController();

  Future<File> getImage({@required ImageSource imageSource}) async {
    File file = await imagePickerService.getPickedImageAsFile(imageSource: ImageSource.gallery);
    file = await imagePickerService.getCroppedImage(imageFile: file);
    return file;
  }

  Widget getCircularProfileImage({@required imagePath}) {

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
          backgroundImage: AssetImage(imagePath)
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
          body: SingleChildScrollView(
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
                     getCircularProfileImage(imagePath: DefaultAssets.profileImagePath),
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
                              onPressed: () {}),
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
