import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';

class VariantGenerator {
  int totalVariants;
  List<String> variantList;
  String selectedVariant;
  String selectedYear;

  void resetVariant() {
    this.selectedVariant = null;
    this.selectedYear = null;
  }

  bool isShowPdf() {
    return selectedYear != null && selectedVariant != null;
  }

  VariantGenerator({this.totalVariants}) {
    this.variantList = List.generate(totalVariants, (index) => (index +1).toString());
  }
}


class ShowSplitPdf extends StatefulWidget {
  final int numberOfSplits ;
  ShowSplitPdf({this.numberOfSplits});

  @override
  _ShowSplitPdfState createState() => _ShowSplitPdfState();

}

class _ShowSplitPdfState extends State<ShowSplitPdf> {

  String pdfPath = "assets/pdfs/Javanotes.pdf";
  String pdfOnlinePath = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

  bool _isLoading = true;
  PDFDocument document;

  List<String> years = [
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
    "2022",
  ];

  List<VariantGenerator> variants;

  Future loadDocumentFromAssetPath({@required String assetPath}) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromAsset(assetPath);
    setState(() => _isLoading = false);
    return;
  }

  @override
  void initState() {
    loadDocumentFromAssetPath(assetPath: pdfPath).then((value) {
      print("DOC LOADED");
    });
    super.initState();
    variants = List.generate(widget.numberOfSplits, (index) => VariantGenerator(totalVariants: 3));
  }

  Widget getExpandedPDFView({@required index}) => Expanded(
    child: !variants[index].isShowPdf() ? Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getCustomDropDown(
            context: context,
            dropDownHint: "Year",
            dropDownItems: years,
            dropDownValue: variants[index].selectedYear,
            onDropDownChanged: (val) {
              setState(() {
                variants[index].selectedYear = val;
              });
            },
          ),
          SizedBox(height: 20,),
          variants[index].selectedYear == null ? Container() : getCustomDropDown(
            context: context,
            dropDownHint: "Variant",
            dropDownItems: variants[index].variantList,
            dropDownValue: variants[index].selectedVariant,
            onDropDownChanged: (val) {
              setState(() {
                variants[index].selectedVariant = val;
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

  @override
  Widget build(BuildContext context) {
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
