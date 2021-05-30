import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';

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
  String selectedSubject;

  static const List<AssetImage> bottomNavBarIcons = [

    AssetImage(DefaultAssets.splitIntoTwo,),
    AssetImage(DefaultAssets.splitIntoThree,),
    AssetImage(DefaultAssets.splitIntoFour,),

  ];

  int selectedItemPosition = 0; // todo change to 0

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare Question Paper"),
      ),
      body: Center(
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
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedItemPosition == index
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                              height: 170,
                              width: 110,
                              // color: selectedItemPosition == index
                              //   ? Colors.blue
                              //   : Colors.transparent,
                              child: Transform.scale(
                                scale: 6,
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: EdgeInsets.all(5),
                                  // constraints: BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      selectedItemPosition = index;
                                    });
                                  },
                                  icon: ImageIcon(
                                    bottomNavBarIcons[index],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  )
            ),
            ElevatedButton(
              onPressed: (){},
              child: Text("Apply"),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}
