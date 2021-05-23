import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {

  String pdfPath = "assets/pdfs/Javanotes.pdf";
  String pdfOnlinePath = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

  bool _isLoading = true;
  PDFDocument document;

  // void loadPDF() async {
  //   // Load from assets
  //   doc = await PDFDocument.fromAsset('assets/pdfs/Javanotes.pdf');
  //
  //   // Load from URL
  //   // PDFDocument doc = await PDFDocument.fromURL('http://www.africau.edu/images/default/sample.pdf');
  //
  //   // Load from file
  //   // File file  = File('...');
  //   // PDFDocument doc = await PDFDocument.fromFile(file);
  //
  // }
  //
  // void setPDFPage(int _number) async {
  //   // Load specific page
  //   PDFPage pageOne = await doc.get(page: _number);
  // }

  Widget customPDFBottomNavBuilder(context, page, totalPages, jumpToPage, animateToPage) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.first_page, color: Colors.white,),
          onPressed: () {
            jumpToPage(page: 0);
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            animateToPage(page: page - 2);
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward, color: Colors.white,),
          onPressed: () {
            animateToPage(page: page);
          },
        ),
        IconButton(
          icon: Icon(Icons.last_page, color: Colors.white,),
          onPressed: () {
            jumpToPage(page: totalPages - 1);
          },
        ),
      ],
    );
  }

  loadDocument() async {
    document = await PDFDocument.fromAsset(pdfPath);


    // document = await PDFDocument.fromURL(pdfOnlinePath);

    // File file  = File('...');
    // PDFDocument doc = await PDFDocument.fromFile(file);

    setState(() => _isLoading = false);
  }

  // changePDF(value) async {
  //   setState(() => _isLoading = true);
  //   if (value == 1) {
  //     document = await PDFDocument.fromAsset('assets/sample2.pdf');
  //   } else if (value == 2) {
  //     document = await PDFDocument.fromURL(
  //       "http://conorlastowka.com/book/CitationNeededBook-Sample.pdf",
  //       /* cacheManager: CacheManager(
  //         Config(
  //           "customCacheKey",
  //           stalePeriod: const Duration(days: 2),
  //           maxNrOfCacheObjects: 10,
  //         ),
  //       ), */
  //     );
  //   } else {
  //     document = await PDFDocument.fromAsset('assets/sample.pdf');
  //   }
  //   setState(() => _isLoading = false);
  // }



  @override
  void initState() {
    loadDocument();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Testing"),
        actions: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: 300,
                  color: Colors.white38,
                  child: Center(child: Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),)),
                ),
              );
            },
            child: Text("Show"),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
          document: document,
          zoomSteps: 1,

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




          //uncomment below line to preload all pages
          lazyLoad: true,
          // uncomment below line to scroll vertically
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
