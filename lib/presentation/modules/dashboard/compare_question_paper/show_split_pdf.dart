import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';

class VariantGenerator {

  final List<QuestionPaperYearModel> questionPaperYears;
  int? selectedVariant;
  int? selectedYear;

  void resetVariant() {
    this.selectedVariant = null;
    this.selectedYear = null;
  }

  bool isShowPdf() {
    return selectedYear != null && selectedVariant != null;
  }

  String? getSelectedDocumentUrl() {
    if (isShowPdf()) {
      return this.questionPaperYears.firstWhere((element) => element.year == this.selectedYear)
          .questionPaperModels.firstWhere((element) => element.version == this.selectedVariant).documentUrl;
    } else {
      return null;
    }
  }

  Future<PDFDocument> loadDocumentFromURL({required pdfURL}) async => await PDFDocument.fromURL(pdfURL);

  VariantGenerator({required this.questionPaperYears});

  @override
  String toString() {
    return 'VariantGenerator{questionPaperYears: $questionPaperYears, selectedVariant: $selectedVariant, selectedYear: $selectedYear}';
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
  late List<VariantGenerator> variants;

  @override
  void initState() {
    variants = List.generate(widget.numberOfSplits, (index) => VariantGenerator(
      questionPaperYears: widget.questionPaperYears,
    ));
    super.initState();
  }

  Widget getExpandedPDFView({required int index, required List<VariantGenerator> variants}) {

    return StatefulBuilder(
      builder: (context, setState) {
        return Expanded(
          child: !variants[index].isShowPdf() ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utils.getCustomDropDown<int>(
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

                      return Utils.getCustomDropDown<int>(
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
          ): FutureBuilder(
              future: variants[index].loadDocumentFromURL(pdfURL: variants[index].getSelectedDocumentUrl()),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                  return Center(child: CircularProgressIndicator.adaptive(),);
                }

                PDFDocument document = snapshot.data as PDFDocument;

                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: PDFViewer(
                        document: document,
                        zoomSteps: 3,
                        panLimit: 20,
                        showNavigation: false,
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
                );
              }
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
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
