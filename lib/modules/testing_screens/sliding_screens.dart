import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';

import '../../config/default_assets.dart';

// import 'package:intro_slider_example/home.dart';
class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  Function goToTab;

  String welcomeText1 =
      "1.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.";
  String welcomeText2 =
      "2.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.";
  String welcomeText3 =
      "3.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.";

  Slide getSlide(
      {@required String descriptionText, @required String imagePath}) {
    return Slide(
      description: descriptionText,
      styleDescription: TextStyle(
        color: Color(0xfffe9c8f),
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        // fontFamily: 'Raleway'
      ),
      pathImage: imagePath,
    );
  }

  @override
  void initState() {
    super.initState();
    slides.add(
      getSlide(
          descriptionText: welcomeText1,
          imagePath: DefaultAssets.welcomeScreenPath),
    );
    slides.add(
      getSlide(
          descriptionText: welcomeText2,
          imagePath: DefaultAssets.welcomeScreenPath),
    );
    slides.add(
      getSlide(
          descriptionText: welcomeText3,
          imagePath: DefaultAssets.welcomeScreenPath),
    );
  }

  void onDonePress() {
    // Back to the first tab
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
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
      colorSkipBtn: Color(0x33ffcc5c),
      highlightColorSkipBtn: Color(0xffffcc5c),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33ffcc5c),
      highlightColorDoneBtn: Color(0xffffcc5c),

      // Dot indicator
      colorDot: Color(0xffffcc5c),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
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
