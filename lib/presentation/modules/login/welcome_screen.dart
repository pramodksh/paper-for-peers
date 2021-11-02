import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:papers_for_peers/config/colors.dart';
import 'package:papers_for_peers/config/export_config.dart';

import '../dashboard/main_dashboard.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  Function goToTab;

  String welcomeText1 =
      "We Provide you the Feature of Downloading Notes And Question Paper";
  String welcomeText2 =
      "2.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.";
  String welcomeText3 =
      "3.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.";

  Slide getSlide(
      {@required String descriptionText, @required String imagePath}) {
    return Slide(
      description: descriptionText,
      backgroundColor: Color(0xfff5a623),
      styleDescription: TextStyle(
        color: Color(0xfffe9c8f),
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        // fontFamily: 'Raleway'
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
          imagePath: DefaultAssets.welcomeScreen2Path),
    );
    slides.add(
      getSlide(
          descriptionText: welcomeText3,
          imagePath: DefaultAssets.welcomeScreen1Path),
    );
  }

  void onDonePress() {
    // Back to the first tab
    // this.goToTab(0);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
      // WelcomeMessage(),
      MainDashboard(),
    ));
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
            margin: EdgeInsets.only(bottom: 60.0, top: 100.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 50,),
                GestureDetector(
                    child: Image.asset(
                      currentSlide.pathImage,
                      width: 280.0,
                      height: 280.0,
                      fit: BoxFit.contain,
                    )),
                SizedBox(height: 100,),
                Container(
                  child: Text(
                    currentSlide.description,
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