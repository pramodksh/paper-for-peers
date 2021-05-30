// import 'dart:html';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfTesting extends StatefulWidget {
  @override
  _PdfTestingState createState() => _PdfTestingState();
}


class _PdfTestingState extends State<PdfTesting> {

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDocumentFromAssetPath(assetPath: pdfPath).then((value) {
      print("DOC LOADED");
    });
  }

  Widget getExpandedPDFView({@required index}) => Expanded(
    child: Stack(
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

    print("DOC: ${document}");
    return Scaffold(
      body: _isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SafeArea(
        child: Column(
          children: List.generate(2, (index) => getExpandedPDFView(index: index)),
        ),
      ),
    );
  }
}
