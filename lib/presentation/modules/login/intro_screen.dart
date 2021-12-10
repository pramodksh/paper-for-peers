import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/repositories/shared_preference/shared_preference_repository.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  Function? goToTab;

  String welcomeText1 =
      "Get easy access to all your study materials";
  String welcomeText2 =
      "We provide you the feature of downloading all the available documents";
  String welcomeText3 =
      "Help others by sharing your Notes along with other study materials";

  Slide getSlide({required String descriptionText, required String imagePath}) {
    return Slide(
      description: descriptionText,
      backgroundColor: Color(0xfff5a623),
      styleDescription: TextStyle(
        color: Color(0xfffe9c8f),
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
      pathImage: imagePath,
      colorBegin: Color(0xffFFFACD),
      colorEnd: Color(0xffFF6347),
      directionColorBegin: Alignment.topRight,
      directionColorEnd: Alignment.bottomLeft,
    );
  }

  @override
  void initState() {
    super.initState();
    slides.add(
      getSlide(
          descriptionText: welcomeText1,
          imagePath: DefaultAssets.welcomeScreen1Path),
    );
    slides.add(
      getSlide(
          descriptionText: welcomeText2,
          imagePath: DefaultAssets.welcomeScreen1Path),
    );
    slides.add(
      getSlide(
          descriptionText: welcomeText3,
          imagePath: DefaultAssets.welcomeScreen2Path),
    );
  }

  void onDonePress() {
    Navigator.of(context).pop();
    context.read<SharedPreferenceRepository>().setIsShowIntroScreen(false);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.white,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.white,
    );
  }


  Widget getBottomNavBarRow(int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppConstants.bottomNavBarIcons[index]["icon"],
            width: 80,
            height: 80,
            color: Colors.white,
          ),
          SizedBox(height: 5,),
          Text(
            AppConstants.bottomNavBarIcons[index]["label"],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> renderListCustomTabs() {
      List<Widget> tabs = [];
      for (int i = 0; i < slides.length; i++) {
        Slide currentSlide = slides[i];
        tabs.add(Container(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Builder(
                    builder: (context) {
                      if (i==0) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [0,1].map((index) {
                                  return getBottomNavBarRow(index);
                                }).toList(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [2,3].map((index) {
                                  return getBottomNavBarRow(index);
                                }).toList(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [4].map((index) {
                                  return getBottomNavBarRow(index);
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return GestureDetector(
                            child: Image.asset(
                              currentSlide.pathImage!,
                              width: 280.0,
                              height: 280.0,
                              fit: BoxFit.contain,
                            ));
                      }
                    },
                  ),
                  SizedBox(height: i==0 ? 10 : 100,),
                  Container(
                    child: Text(
                      currentSlide.description!,
                      style: currentSlide.styleDescription,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: EdgeInsets.only(top: 20.0),
                  ),
                ],
              ),
            ),
          ));
      }
      return tabs;
    }

    return new IntroSlider(
      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: CustomColors.backGroundColor,
      highlightColorSkipBtn: CustomColors.backGroundColor,

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: CustomColors.backGroundColor,
      highlightColorDoneBtn: CustomColors.backGroundColor,

      // Dot indicator
      colorDot: Colors.white,
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: renderListCustomTabs(),
      backgroundColorAllSlides: CustomColors.bottomNavBarColor,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: BouncingScrollPhysics(),

      // Show or hide status bar
      hideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
