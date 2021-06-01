// import 'dart:html';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';


class VariantGenerator {
  int total;
  List<String> list;
  VariantGenerator({this.total}) {
    print("total: $total");
    this.list = List.generate(total, (index) => (index +1).toString());
    print("list: $list");
  }
}


class SplitScreen extends StatefulWidget {
  final int numberOfSplits ;
  SplitScreen({this.numberOfSplits});


  @override
  _SplitScreenState createState() => _SplitScreenState();

}


class _SplitScreenState extends State<SplitScreen> {

  String pdfPath = "assets/pdfs/Javanotes.pdf";
  String pdfOnlinePath = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

  bool _isLoading = true;
  PDFDocument document;

  Future loadDocumentFromAssetPath({@required String assetPath}) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromAsset(assetPath);
    setState(() => _isLoading = false);
    return;
  }

  // int numberOfSplit = selectedItemPosition;
  List<bool> isPDF;

  List<String> years = [
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
    "2022",
  ];
  VariantGenerator obj = new VariantGenerator(total: 3);  // total -> number of variants available
  // List<String> variants = ["1", "2", "3"];
  String selectedVariant;
  String selectedQuestionPaperYear;
   // bool isSelectedQuestionPaper = false;
  List<bool> isSelectedQuestionPaper ;

  @override
  void initState() {
    loadDocumentFromAssetPath(assetPath: pdfPath).then((value) {
      print("DOC LOADED");
    });
    super.initState();
    print(selectedVariant);

    print(isSelectedQuestionPaper);
    isSelectedQuestionPaper = List.generate(widget.numberOfSplits, (index) => false);
    isPDF = List.generate(widget.numberOfSplits, (index) => false);

    int num = 5;
  }
  /*
  selected year
  selected variant
  int totalVariants
   */


  Widget getExpandedPDFView({@required index}) => Expanded(
    child: !isPDF[index] ? Container(
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getCustomDropDown(
            context: context,
            dropDownHint: "Year",
            dropDownItems: years,
            dropDownValue: selectedQuestionPaperYear,
            onDropDownChanged: (val) {
              print("VAL: $val");
              setState(() {
                selectedQuestionPaperYear = val;
                isSelectedQuestionPaper[index] = true;

              });
            },
          ),
          SizedBox(height: 20,),
          !isSelectedQuestionPaper[index]?Container():getCustomDropDown(
            context: context,
            dropDownHint: "Variant",
            dropDownItems: obj.list,
            dropDownValue: selectedVariant,
            onDropDownChanged: (val) {
              print("VAL2: $val");
              setState(() {
                selectedVariant = val;
                isPDF[index] =true;
              });
            },
          ),
        ],
      ),
    ):Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: PDFViewer(
            document: document,
            zoomSteps: 3,
            panLimit: 20,

            showNavigation: false,
            // navigationBuilder: customPDFBottomNavBuilder,


            showPicker: false,
            pickerButtonColor: Colors.black,
            pickerIconColor: Colors.red,

            enableSwipeNavigation: true,

            progressIndicator: Text("Loading", style: TextStyle(fontSize: 20),),


            indicatorPosition: IndicatorPosition.topLeft,
            indicatorBackground: Colors.black,
            indicatorText: Colors.white,
            // showIndicator: false,

            lazyLoad: true,

            scrollDirection: Axis.vertical,
          ),
        ),
        Positioned(
          right: 0,
          top: 10,
          child: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              print("CLOSE $index");
            },
            icon: Icon(Icons.close, size: 30, color: Colors.indigo,),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {


    // print("DOC: ${document} | ${widget.numberOfSplits} | ${years} | ${variants}");
    return Scaffold(
      body: _isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: List.generate(widget.numberOfSplits, (index) => getExpandedPDFView(index: index)),
            // children: List.generate( (index) => getExpandedPDFView(index: index)),
          ),
        ),
      ),
    );
  }
}
