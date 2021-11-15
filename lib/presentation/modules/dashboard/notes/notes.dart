import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/post_tiles.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/src/provider.dart';

class Notes extends StatefulWidget {
  final bool isDarkTheme;

  Notes({required this.isDarkTheme});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  List<String> subjects = [
    "A",
    "B",
    "C",
  ];
  String? selectedSubject;


  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);

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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 140,
                child: getAddPostContainer(
                  isDarkTheme: appThemeType.isDarkTheme(),
                  context: context,
                  onPressed: () {},
                  label: "Add Notes",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
