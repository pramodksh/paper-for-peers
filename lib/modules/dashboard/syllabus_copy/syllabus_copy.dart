import 'package:flutter/material.dart';
import 'package:papers_for_peers/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/modules/dashboard/shared/PDF_viewer_screen.dart';

class SyllabusCopy extends StatefulWidget {
  @override
  _SyllabusCopyState createState() => _SyllabusCopyState();
}

class _SyllabusCopyState extends State<SyllabusCopy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFViewerScreen<PDFScreenSyllabusCopy>(
        screenLabel: "Syllabus Copy",
        parameter: PDFScreenSyllabusCopy(
          uploadedBy: "John Doe",
          nVariant: 1,
          totalVariants: 1,
        ),
      ),
    );
  }
}
