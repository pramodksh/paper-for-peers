import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';

class VariantGenerator {

  final List<QuestionPaperYearModel> questionPaperYears;
  int? selectedVariant;
  int? selectedYear;
  int? currentPageNumber = 0;
  int? totalPages = 0;

  void setPageCount(current, total) {
    this.currentPageNumber = current;
    this.totalPages = total;
  }

  void resetVariant() {
    this.selectedVariant = null;
    this.selectedYear = null;
  }

  bool isShowPdf() {
    return selectedYear != null && selectedVariant != null;
  }

  String getSelectedDocumentUrl() {
    return this.questionPaperYears.firstWhere((element) => element.year == this.selectedYear)
        .questionPaperModels.firstWhere((element) => element.version == this.selectedVariant).documentUrl;
  }

  VariantGenerator({required this.questionPaperYears,});

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
          ) : Stack(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: PDF(
                    onPageChanged: (page, total) {
                      setState(() {
                        variants[index].setPageCount(page, total);
                      });
                    },
                  ).cachedFromUrl(
                    variants[index].getSelectedDocumentUrl(),
                    placeholder: (progress) => Center(child: Text("Loading", style: TextStyle(fontSize: 20),)),
                    errorWidget: (error) => Center(child: Text("There was an error while loading pdf", style: TextStyle(fontSize: 20),)),
                  ),
              ),
              Builder(
                builder: (context) {
                  if (variants[index].currentPageNumber != null && variants[index].totalPages != null) {
                    return Positioned(
                      top: 10,
                      right: 10,
                      child: Text("${variants[index].currentPageNumber! + 1} / ${variants[index].totalPages}", style: TextStyle(fontSize: 16, color: Colors.black),),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              Positioned(
                right: 0,
                top: 20,
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
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
