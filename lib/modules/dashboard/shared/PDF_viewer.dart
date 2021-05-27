import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFViewerScreen extends StatefulWidget {
  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {

  String pdfPath = "assets/pdfs/Javanotes.pdf";
  String pdfOnlinePath = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

  bool _isLoading = true;
  PDFDocument document;

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

  Future loadDocumentFromAssetPath({@required String assetPath}) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromAsset(assetPath);
    setState(() => _isLoading = false);
    return;
  }

  void loadDocumentFromURL({@required pdfURL}) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromURL(pdfURL);
    setState(() => _isLoading = false);
  }

  void loadDocumentFromFile() {
    // File file  = File('...');
    // PDFDocument doc = await PDFDocument.fromFile(file);
  }

  Widget _buildBottomModel() {

    double modelHeight = 300;
    double ratingHeight = 30;
    double ratingBorderRadius = 20;
    double ratingWidth = 100;
    double ratingRightPosition = 10;

    return Stack(
      children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(ratingBorderRadius), topRight: Radius.circular(ratingBorderRadius)),
            ),
            height: ratingHeight,
            width: ratingWidth,
            child: Center(child: Text("HI", style: TextStyle(fontWeight: FontWeight.w600),)),
          ),
          right: ratingRightPosition,
        ),
        Container(
            margin: EdgeInsets.only(top: ratingHeight),
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20))
            ),
            height: modelHeight,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Scroll", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                  Text("HI", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700)),
                ],
              ),
            )
        ),
      ],
    );
  }

  void _showCustomBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      context: context,
      builder: (context) => _buildBottomModel(),
    );
  }

  @override
  void initState() {
    loadDocumentFromAssetPath(assetPath: pdfPath).then((value) {
      _showCustomBottomSheet();
    });
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
              _showCustomBottomSheet();
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

          lazyLoad: true,

          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
