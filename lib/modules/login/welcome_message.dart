import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';

class WelcomeMessage extends StatefulWidget {
  _WelcomeMessageState createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> {

  final PageController _controller = PageController();
  List<Widget> _list = [];
  PageIndicatorContainer container;

  Widget getSliderBox({
    @required String sliderText,
    @required String sliderImage}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            sliderImage,
            height: 300,
            alignment: Alignment.center,
          ),
          SizedBox(height: 30,),
          Text(
            sliderText,
            style: CustomTextStyle.bodyTextStyle.copyWith(
              decoration: TextDecoration.none,
              fontSize: 22,
              fontWeight: FontWeight.w600, color: Colors.black,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
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

  void _setSlider() {
    _list = [
      getSliderBox(
        sliderText: 'We Provide you the Feature of Downloading Notes and Question Paper.',
        sliderImage: DefaultAssets.welcomeScreenPath,
      ),
      getSliderBox(
        sliderText: 'We Provide you the Feature of Downloading Notes and Question Paper.',
        sliderImage: DefaultAssets.welcomeScreenPath,
      ),
      getSliderBox(
        sliderText: 'We Provide you the Feature of Downloading Notes and Question Paper.',
        sliderImage: DefaultAssets.welcomeScreenPath,
      ),
    ];

    container = new PageIndicatorContainer(
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
  }


  @override
  void initState() {
    _setSlider();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _animateSlider();
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