import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/default_assets.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/compare_question_paper/show_split_pdf.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';

class ShowSplitOptions extends StatefulWidget {
  @override
  _ShowSplitOptionsState createState() => _ShowSplitOptionsState();
}

class _ShowSplitOptionsState extends State<ShowSplitOptions> {
  List<String> subjects = [
    "A",
    "B",
    "C",
  ];

  String? selectedSubject;

  List<Map> splitOptions= [
    {'image': DefaultAssets.splitIntoTwo, 'label': "2 Splits"},
    {'image': DefaultAssets.splitIntoThree, 'label': "3 Splits"},
    {'image': DefaultAssets.splitIntoFour, 'label': "4 Splits"},
  ];

  int selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

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
            getCustomDropDown<String>(
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
                  splitOptions.length,
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
                                  print('Theme : ${appThemeType.isDarkTheme()}');
                                });
                              },
                              child: Builder(
                                builder: (context) {
                                  Color selectedSplitColor;

                                  if (appThemeType.isDarkTheme()) {
                                    selectedSplitColor = CustomColors.bottomNavBarColor;
                                  } else {
                                    selectedSplitColor = Colors.black12;
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: selectedItemPosition == index ? selectedSplitColor : Colors.transparent,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    child: Image.asset(splitOptions[index]['image']),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text(splitOptions[index]['label'])
                          ],
                        ),
                      )),
            )),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowSplitPdf(numberOfSplits: selectedItemPosition + 2,),

                ));
              },
              child: Text("Apply"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor :CustomColors.lightModeBottomNavBarColor)),
            )
          ],
        ),
      ),
    );
  }
}
