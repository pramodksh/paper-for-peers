import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';

class VariantGenerator {

  final List<QuestionPaperYearModel> questionPaperYears;
  // final PDFDocument document;


  int totalVariants;
  late List<String> variantList;
  int? selectedVariant;
  int? selectedYear;

  void resetVariant() {
    this.selectedVariant = null;
    this.selectedYear = null;
  }

  bool isShowPdf() {
    return selectedYear != null && selectedVariant != null;
  }

  VariantGenerator({required this.totalVariants, required this.questionPaperYears}) {
    this.variantList = List.generate(totalVariants, (index) => (index +1).toString());
  }
}


class ShowSplitPdf extends StatefulWidget {

  final List<QuestionPaperYearModel> questionPaperYears;
  final int numberOfSplits;

  ShowSplitPdf({required this.numberOfSplits, required this.questionPaperYears});

  @override
  _ShowSplitPdfState createState() => _ShowSplitPdfState();

}

class _ShowSplitPdfState extends State<ShowSplitPdf> {

  // String pdfOnlinePath = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

  bool _isLoading = false;
  late PDFDocument document;

  late List<VariantGenerator> variants;

  // Future loadDocumentFromAssetPath({required String assetPath}) async {
  //   setState(() => _isLoading = true);
  //   document = await PDFDocument.fromAsset(assetPath);
  //   setState(() => _isLoading = false);
  //   return;
  // }

  @override
  void initState() {
    // loadDocumentFromAssetPath(assetPath: pdfPath).then((value) {
    //   print("DOC LOADED");
    // });
    super.initState();
    variants = List.generate(widget.numberOfSplits, (index) => VariantGenerator(
      totalVariants: 3, questionPaperYears: widget.questionPaperYears,
    ));
  }

  Widget getExpandedPDFView({required int index, required List<VariantGenerator> variants}) {

    // print("SEE: ${variants.map((e) => e.questionPaperYears.map((e) => e.questionPaperModels.map((e) => e.version).length).toList()).toList()[index]}");

    // print("SEE: ${variants.map((e) => e.questionPaperYears.map((e) => e.questionPaperModels.map((e) => e.version).toList()).toList()).toList()[index]}");

    if (variants[index].selectedYear != null) {
      // print("SEE: ${variants[index].questionPaperYears.firstWhere((element) => element.year == int.parse(variants[index].selectedYear!))}");
      QuestionPaperYearModel selectedYearModel = variants[index].questionPaperYears.firstWhere((element) => element.year == variants[index].selectedYear!);
      print("SEE: ${selectedYearModel.questionPaperModels.map((e) => e.version).toList()}");
    }
    return Expanded(
      child: !variants[index].isShowPdf() ? Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getCustomDropDown<int>(
              context: context,
              dropDownHint: "Year",
              dropDownItems: variants.map((e) => e.questionPaperYears.map((e) => e.year).toList()).toList()[index],
              dropDownValue: variants[index].selectedYear,
              onDropDownChanged: (val) {
                setState(() {
                  variants[index].selectedYear = val;
                });
              },
            ),
            SizedBox(height: 20,),
            variants[index].selectedYear == null ? Container() : Builder(
              builder: (context) {
                QuestionPaperYearModel selectedYearModel = variants[index].questionPaperYears.firstWhere((element) => element.year == variants[index].selectedYear!);
                print("SEE: ${selectedYearModel.questionPaperModels.map((e) => e.version).toList()}");

                return getCustomDropDown<int>(
                  context: context,
                  dropDownHint: "Variant",
                  dropDownItems: selectedYearModel.questionPaperModels.map((e) => e.version).toList(),
                  dropDownValue: variants[index].selectedVariant,
                  onDropDownChanged: (val) {
                    setState(() {
                      variants[index].selectedVariant = val;
                    });
                  },
                );
              }
            ),
          ],
        ),
      ): Stack(
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
                setState(() {
                  variants[index].resetVariant();
                });
              },
              icon: Icon(Icons.close, size: 30, color: Colors.indigo,),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: List.generate(widget.numberOfSplits, (index) => getExpandedPDFView(
              index: index, variants: variants,
            )),
            // children: List.generate( (index) => getExpandedPDFView(index: index)),
          ),
        ),
      ),
    );
  }
}
