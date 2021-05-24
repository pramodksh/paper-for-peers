//-----------------------Start Here------------------------------

// import 'package:flutter/material.dart';
// import 'package:intro_slider/intro_slider.dart';
// import 'package:intro_slider/slide_object.dart';
//
// void main() => runApp(new MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: IntroScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class IntroScreen extends StatefulWidget {
//   IntroScreen({Key key}) : super(key: key);
//
//   @override
//   IntroScreenState createState() => new IntroScreenState();
// }
// class IntroScreenState extends State<IntroScreen> {
//  List<Slide> slides = [];
//
//  @override
//  void initState() {
//    super.initState();
//
//    slides.add(
//      new Slide(
//        title: "ERASER",
//        description: "Allow miles wound place the leave had. To sitting subject no improve studied limited",
//        pathImage: "assets\\images\\welcomeScreen1.png",
//        backgroundColor: Color(0xfff5a623),
//      ),
//    );
//    slides.add(
//      new Slide(
//        title: "PENCIL",
//        description: "Ye indulgence unreserved connection alteration appearance",
//        pathImage: "assets\\images\\welcomeScreen1.png",
//        backgroundColor: Color(0xff203152),
//      ),
//    );
//    slides.add(
//      new Slide(
//        title: "RULER",
//        description:
//        "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
//        pathImage: "assets\\images\\welcomeScreen1.png",
//        // backgroundImage:  "assets\\images\\welcomeScreen1.png",
//        heightImage: 450,
//        backgroundColor: Color(0xff9932CC),
//      ),
//    );
//  }
//
//  void onDonePress() {
//    // Do what you want
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new IntroSlider(
//      slides: this.slides,
//      onDonePress: this.onDonePress,
//    );
//  }
// }

//---------------------------End Here--------------------------

import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

class Carousel extends StatefulWidget {
  _CarouselState createState() => _CarouselState();
}


class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {

  SliderBox getSliderBox({@required String sliderText, @required String sliderImage}) {
    return SliderBox(
      child: Container(
        // height:MediaQuery.of(context).size.height *.75 ,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets\\images\\welcomeScreen1.png',
              height: 500,
              alignment: Alignment.center,
            ),
            Container(
              // color: Colors.blue,
              // width: MediaQuery.of(context).size.width * 0.75,
              child: Text(
                'We Provide you the Feature of Downloading Notes and Question Paper.',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 22,
                  fontWeight: FontWeight.w600, color: Colors.black,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  final PageController _controller = PageController();

  List<Widget> _list;

  @override
  void initState() {
    _list = [
      getSliderBox(
          sliderText: 'We Provide you the Feature of Downloading Notes and Question Paper.',
          sliderImage: "assets\\images\\welcomeScreen1.png"
      ),
      getSliderBox(
          sliderText: 'We Provide you the Feature of Downloading Notes and Question Paper.',
          sliderImage: "assets\\images\\welcomeScreen1.png"
      ),
      getSliderBox(
          sliderText: 'We Provide you the Feature of Downloading Notes and Question Paper.',
          sliderImage: "assets\\images\\welcomeScreen1.png"
      ),
    ];

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
  }

  void _animateSlider() {
    Future.delayed(Duration(seconds: 5)).then((_) {
      int nextPage = _controller.page.round() + 1;

      if (nextPage == _list.length) {
        nextPage = 0;
      }

      _controller
          .animateToPage(
          nextPage, duration: Duration(seconds: 1), curve: Curves.linear)
          .then((_) => _animateSlider());
    });
  }

  @override
  Widget build(BuildContext context) {
    PageIndicatorContainer container = new PageIndicatorContainer(
      pageView: new PageView(
        children: _list,
        controller: _controller,
      ),
      length: _list.length,
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
      indicatorSpace: 10,
      indicatorColor: Colors.grey[350],
      indicatorSelectorColor: Colors.grey,
    );

    return Stack(
      children: <Widget>[
        Container(color: Colors.grey[100], height: double.infinity),
        Container(color: Colors.white,
            child: container,
            margin: EdgeInsets.only(bottom: 50)),
      ],
    );
  }
}

class SliderBox extends StatelessWidget {
  final Widget child;

  const SliderBox({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10), child: child);
  }
}
