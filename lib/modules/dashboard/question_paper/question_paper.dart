import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/modules/dashboard/shared/PDF_viewer.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';

class QuestionPaper extends StatefulWidget {
  @override
  _QuestionPaperState createState() => _QuestionPaperState();
}

class _QuestionPaperState extends State<QuestionPaper> {

  List<String> subjects = [
    "A",
    "B",
    "C",
  ];
  String selectedSubject;

  List<String> years = [
    "2017",
    "2018",
    "2019",
    "2010",
  ];

  Widget getAddPostContainer({
    @required String label,
    @required Function onPressed,
    double containerHeight = 80,
    double containerWidth = 180,
    double containerMargin = 20,
    double containerRadius = 15,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(right: containerMargin),
        child: DottedBorder(
          padding: EdgeInsets.zero,
          color: CustomColors.bottomNavBarUnselectedIconColor,
          dashPattern: [8, 4],
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: Radius.circular(containerRadius),
          child: Container(
            height: containerHeight,
            width: containerWidth,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 15, color: CustomColors.bottomNavBarUnselectedIconColor, fontWeight: FontWeight.w500)),
                SizedBox(height: 8,),
                Image.asset(
                  DefaultAssets.addPostIcon,
                  color: CustomColors.bottomNavBarUnselectedIconColor,
                  scale: 0.9,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getQuestionVariantContainer({
    @required int nVariant,
    @required Function onPressed,
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
          color: CustomColors.bottomNavBarColor,
          borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
        ),
      ),
    );
  }

  Widget getQuestionYearTile({@required String year, @required List<Widget> children}) {
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
                ? Container() // todo add child
                : ListView.separated(
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
                              builder: (context) => PDFViewerScreen<PDFScreenQuestionPaper>(
                                screenLabel: "Question Paper",
                                parameter: PDFScreenQuestionPaper(
                                  year: years[index],
                                  nVariant: 1,
                                  uploadedBy: "John Doe",
                                ),
                              ),
                            ));
                          },
                          nVariant: 1
                      ),
                      getAddPostContainer(
                          label: "Add Question Paper",
                          onPressed: () {}
                      ),
                    ]
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
