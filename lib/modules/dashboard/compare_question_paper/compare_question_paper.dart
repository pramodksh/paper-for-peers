import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/modules/dashboard/compare_question_paper/splitPDF.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class CompareQuestionPaper extends StatefulWidget {
  @override
  _CompareQuestionPaperState createState() => _CompareQuestionPaperState();
}

class _CompareQuestionPaperState extends State<CompareQuestionPaper> {
  List<String> subjects = [
    "A",
    "B",
    "C",
  ];

  List<String> numberOfSplits = ['2 Splits','3 Splits','4 Splits'];
  String selectedSubject;

  List<Widget> bottomNavBarIcons = [
    Image.asset(
      DefaultAssets.splitIntoTwo,
    ),
    Image.asset(
      DefaultAssets.splitIntoThree,
    ),
    Image.asset(
      DefaultAssets.splitIntoFour,
    ),
  ];

  int selectedItemPosition = 0; // todo change to 0

  @override
  Widget build(BuildContext context) {
    var themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare Question Paper"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getCustomDropDown(
              context: context,
              dropDownHint: "Subject",
              dropDownItems: subjects,
              dropDownValue: selectedSubject,
              onDropDownChanged: (val) {
                setState(() {
                  selectedSubject = val;
                });
              },
            ),
            Text("How many Question Papers you want to Compare?"),
            Container(
                // color: Colors.red,
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  bottomNavBarIcons.length,
                  (index) => SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedItemPosition = index;
                                  print('Theme : ${themeChange.isDarkTheme}');
                                });
                              },
                              child: Builder(
                                builder: (context) {
                                  Color selectedIconColor;
                                  Color unselectedIconColor;

                                  if (themeChange.isDarkTheme) {
                                    selectedIconColor = CustomColors
                                        .bottomNavBarColor;
                                    unselectedIconColor = Colors.transparent;
                                  } else {
                                    selectedIconColor = Colors.black12;
                                    unselectedIconColor = Colors.transparent;
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: selectedItemPosition == index ? selectedIconColor : Colors.transparent,
                                    ),

                                    // margin: EdgeInsets.symmetric(horizontal: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                                    child: bottomNavBarIcons[index],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text(numberOfSplits[index])
                          ],
                        ),
                      )),
            )),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SplitScreen(numberOfSplits: selectedItemPosition + 2,),

                ));
              },
              child: Text("Apply"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(themeChange.isDarkTheme ? CustomColors.bottomNavBarColor :CustomColors.lightModeBottomNavBarColor)),
            )
          ],
        ),
      ),
    );
  }
}
