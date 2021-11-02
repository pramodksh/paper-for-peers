import 'package:flutter/material.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/upload/shared.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';

class UploadQuestionPaper extends StatefulWidget {
  @override
  _UploadQuestionPaperState createState() => _UploadQuestionPaperState();
}

class _UploadQuestionPaperState extends State<UploadQuestionPaper> {

  String selectedSubject;
  String selectedYear;
  String selectedSemester;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Question Paper",
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: getAddPostContainer(
                context: context,
                label: "Select File",
                onPressed: () {},
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: getCustomDropDown(
                      context: context,
                      dropDownHint: "Subject",
                      dropDownItems: ["CPP", "JAVA"],
                      onDropDownChanged: (val) { setState(() { selectedSubject = val; }); },
                      dropDownValue: selectedSubject,
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: getCustomDropDown(
                      context: context,
                      dropDownHint: "Year",
                      dropDownItems: ["2016", "2107"],
                      onDropDownChanged: (val) { setState(() { selectedYear = val; }); },
                      dropDownValue: selectedYear,
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: getCustomDropDown(
                      context: context,
                      dropDownHint: "Semester",
                      dropDownItems: List.generate(6, (index) => "Semester - ${index + 1}"),
                      onDropDownChanged: (val) { setState(() { selectedSemester = val; }); },
                      dropDownValue: selectedSemester,
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(child: UploadNotesBody()),
            getUploadButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}