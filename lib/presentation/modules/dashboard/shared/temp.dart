import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class DemoPdf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hi"),
      ),
      body: Container(
        child: PDF().cachedFromUrl(
          'http://africau.edu/images/default/sample.pdf',
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
        )
      ),
    );
  }
}
