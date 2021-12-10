import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/text_styles.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class VariantGenerator {

  final List<QuestionPaperYearModel> questionPaperYears;
  String? selectedVariantId;
  int? selectedYear;
  int? currentPageNumber = 0;
  int? totalPages = 0;

  void setPageCount(current, total) {
    this.currentPageNumber = current;
    this.totalPages = total;
  }

  void resetVariant() {
    this.selectedVariantId = null;
    this.selectedYear = null;
  }

  bool isShowPdf() {
    return selectedYear != null && selectedVariantId != null;
  }

  String getSelectedDocumentUrl() {
    return this.questionPaperYears.firstWhere((element) => element.year == this.selectedYear)
        .questionPaperModels.firstWhere((element) => element.id == this.selectedVariantId).documentUrl;
  }

  VariantGenerator({required this.questionPaperYears,});

  @override
  String toString() {
    return 'VariantGenerator{questionPaperYears: $questionPaperYears, selectedVariant: $selectedVariantId, selectedYear: $selectedYear}';
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

  Widget getExpandedPDFView({required int index, required List<VariantGenerator> variants, required bool isDarkTheme}) {

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
                      return Utils.getCustomDropDown<String>(
                        context: context,
                        dropDownHint: "Variant",
                        dropDownItems: selectedYearModel.questionPaperModels.map((e) => e.id).toList(),
                        dropDownValue: variants[index].selectedVariantId,
                        onDropDownChanged: (val) {
                          setState(() {
                            variants[index].selectedVariantId = val;
                          });
                        },
                        items: List.generate(selectedYearModel.questionPaperModels.length, (index) {
                          return DropdownMenuItem<String>(
                            value: selectedYearModel.questionPaperModels[index].id,
                            child: Text((index+1).toString(), style: CustomTextStyle.bodyTextStyle.copyWith(
                              fontSize: 18,
                              color: isDarkTheme ? Colors.white60 : Colors.black,
                            ),),
                          );
                        }),
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

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

    return Scaffold(
      body:  SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: List.generate(widget.numberOfSplits, (index) => getExpandedPDFView(
              isDarkTheme: appThemeType.isDarkTheme(),
              index: index, variants: variants,
            )),
            // children: List.generate( (index) => getExpandedPDFView(index: index)),
          ),
        ),
      ),
    );
  }
}
