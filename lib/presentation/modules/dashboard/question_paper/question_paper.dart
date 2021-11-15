import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/compare_question_paper/show_split_options.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';

class QuestionPaper extends StatefulWidget {
  final bool isDarkTheme;

  QuestionPaper({required this.isDarkTheme});

  @override
  _QuestionPaperState createState() => _QuestionPaperState();
}

class _QuestionPaperState extends State<QuestionPaper> {

  List<String> subjects = [
    "A",
    "B",
    "C",
  ];
  String? selectedSubject;

  List<String> years = [
    "2017",
    "2018",
    "2019",
    "2010",
  ];

  Widget getQuestionVariantContainer({
    required int nVariant,
    required Function() onPressed,
    double containerRadius = 15,
    double containerHeight = 80,
    double containerWidth = 180,
    double containerMargin = 20,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(right: containerMargin),
        height: containerHeight,
        width: containerWidth,
        child: Center(child: Text("Variant $nVariant", style: TextStyle(fontSize: 18, color: CustomColors.bottomNavBarUnselectedIconColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),)),
        decoration: BoxDecoration(
          color: widget.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
          borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
        ),
      ),
    );
  }

  Widget getQuestionYearTile({required String year, required List<Widget> children}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(year, style: TextStyle(fontSize: 44, color: Colors.white38),),
          SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getCourseText(course: "BCA", semester: 6),
                  getCustomDropDown(
                    context: context,
                    dropDownHint: "Subject",
                    dropDownItems: subjects,
                    dropDownValue: selectedSubject,
                    onDropDownChanged: (val) { setState(() { selectedSubject = val; }); },
                  ),
                ],
              ),
              SizedBox(height: 30,),
              selectedSubject == null
                ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(child: Text("Select Subject to Continue", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,)),
              ) : Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShowSplitOptions(),
                      ));
                    },
                    child: Text("Compare Question Papers", style: TextStyle(fontSize: 18),),
                  ),
                  SizedBox(height: 20,),
                  ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(height: 20,),
                      itemCount: years.length,
                      itemBuilder: (context, index) => getQuestionYearTile(
                        year: years[index],
                        children: [
                          getQuestionVariantContainer(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PDFViewerScreen<PDFScreenSimpleBottomSheet>(
                                    screenLabel: "Question Paper",
                                    parameter: PDFScreenSimpleBottomSheet(
                                      title: years[index],
                                      nVariant: index + 1,
                                      uploadedBy: "John Doe",
                                    ),
                                  ),
                                ));
                              },
                              nVariant: index + 1,
                          ),
                          SizedBox(
                            width: 180,
                            height: 80,
                            child: getAddPostContainer(
                              isDarkTheme: appThemeType.isDarkTheme(),
                              label: "Add Question Paper",
                              onPressed: () {},
                              context: context,
                            ),
                          ),
                        ]
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
