import 'package:flutter/material.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/profile.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/upload/shared.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';

class UploadNotesAndJournal extends StatefulWidget {
  final TypesOfPost typesOfPost;
  final String label;

  UploadNotesAndJournal({this.typesOfPost, this.label});

  @override
  _UploadNotesAndJournalState createState() => _UploadNotesAndJournalState();
}

class _UploadNotesAndJournalState extends State<UploadNotesAndJournal> {

  String selectedSubject;
  String selectedSemester;

  Widget getNotesDetailsTextField({String hintText}) {
    return TextField(
      style: TextStyle(fontSize: 16, color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload ${widget.label}",
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: getAddPostContainer(
                  context: context,
                  label: "Select File",
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.typesOfPost != TypesOfPost.SyllabusCopy ? getCustomDropDown(
                    context: context,
                    dropDownHint: "Subject",
                    dropDownItems: ["CPP", "JAVA"],
                    onDropDownChanged: (val) { setState(() { selectedSubject = val; }); },
                    dropDownValue: selectedSubject,
                  ) : Container(),
                  widget.typesOfPost != TypesOfPost.SyllabusCopy ? SizedBox(width: 20,) : Container(),
                  getCustomDropDown(
                    context: context,
                    dropDownHint: "Semester",
                    dropDownItems: List.generate(6, (index) => (index + 1).toString()),
                    onDropDownChanged: (val) { setState(() { selectedSemester = val; }); },
                    dropDownValue: selectedSemester,
                  ),
                ],
              ),
              widget.typesOfPost == TypesOfPost.Notes ? Container(
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    getNotesDetailsTextField(hintText: "Title"),
                    SizedBox(height: 30,),
                    getNotesDetailsTextField(hintText: "Description"),
                  ],
                ),
              ) : Container(),
              SizedBox(height: 50,),
              getUploadButton(onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}