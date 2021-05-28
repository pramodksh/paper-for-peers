import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/modules/dashboard/utilities/utilities.dart';

class Notes extends StatefulWidget {
  final bool isDarkTheme;

  Notes({this.isDarkTheme});
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  DateFormat dateFormat = DateFormat("dd MMMM yyyy");
  List<String> subjects = [
    "A",
    "B",
    "C",
  ];
  String selectedSubject;

  Widget getNotesDetailsTile({
    @required String title,
    @required String description,
    @required double rating,
    @required String uploadedBy,
    @required DateTime uploadedOn,
    @required onTileTap,
  }) {

    double ratingHeight = 30;
    double ratingWidth = 100;
    double ratingBorderRadius = 20;

    return GestureDetector(
      onTap: onTileTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                padding: EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: widget.isDarkTheme ? CustomColors.ratingBackgroundColor : CustomColors.lightModeRatingBackgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(ratingBorderRadius), topRight: Radius.circular(ratingBorderRadius)),
                ),
                height: 50,
                width: ratingWidth,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(rating.toString(), style: TextStyle(fontWeight: FontWeight.w600),),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              right: 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.only(top: ratingHeight),
              decoration: BoxDecoration(
                  color: widget.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              // height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Text(title, style: TextStyle(fontSize: 28,),),
                        SizedBox(height: 10,),
                        Text(description, style: TextStyle(fontSize: 16,),),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            CircleAvatar(
                              child: FlutterLogo(),
                              radius: 20,
                            ),
                            SizedBox(width: 10,),
                            Text(uploadedBy, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Text(dateFormat.format(uploadedOn)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                onTileTap: () {},
                title: "Title Title Title Title",
                description: "John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
                uploadedBy: "John Doe",
                rating: 3.5,
                uploadedOn: DateTime.now(),
              ),
              getNotesDetailsTile(
                onTileTap: () {},
                title: "Title Title Title",
                description: "Lorem John Doe  John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe John Doe",
                uploadedBy: "John Doe",
                rating: 3.5,
                uploadedOn: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
