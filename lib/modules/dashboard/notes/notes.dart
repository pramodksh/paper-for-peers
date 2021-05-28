import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/post_tiles.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';

class Notes extends StatefulWidget {
  final bool isDarkTheme;

  Notes({this.isDarkTheme});
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  List<String> subjects = [
    "A",
    "B",
    "C",
  ];
  String selectedSubject;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getCourseText(course: "BCA", semester: 6),
                  getCustomDropDown(
                    context: context,
                    dropDownHint: "Subject",
                    dropDownItems: subjects,
                    dropDownValue: selectedSubject,
                    onDropDownChanged: (val) { setState(() { selectedSubject = val; }); },
                  ),
                ],
              ),
              SizedBox(height: 20,),
              getNotesDetailsTile(
                context: context,
                onTileTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PDFViewerScreen<PDFScreenNotesBottomSheet>(
                      screenLabel: "Notes",
                      parameter: PDFScreenNotesBottomSheet(
                        rating: 3.5,
                        uploadedBy: "John Doe",
                        description: "Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John",
                        title: "Title Title Title Title Title Title Title Title",

                      ),
                    ),
                  ));
                },
                title: "Title Title Title Title Title Title Title Title",
                description: "Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
                uploadedBy: "John Doe",
                rating: 3.5,
                uploadedOn: DateTime.now(),
              ),
              getNotesDetailsTile(
                context: context,
                onTileTap: () {},
                title: "Title Title Title Title",
                description: "John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
                uploadedBy: "John Doe",
                rating: 3.5,
                uploadedOn: DateTime.now(),
              ),
              getNotesDetailsTile(
                context: context,
                onTileTap: () {},
                title: "Title Title Title",
                description: "Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
                uploadedBy: "John Doe",
                rating: 3.5,
                uploadedOn: DateTime.now(),
              ),
              SizedBox(height: 20,),
              getAddPostContainer(
                context: context,
                onPressed: () {},
                label: "Add Notes",
                containerWidth: MediaQuery.of(context).size.width,
                containerHeight: 140,
                containerMargin: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
