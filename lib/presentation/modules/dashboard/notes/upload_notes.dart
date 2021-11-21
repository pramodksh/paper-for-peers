import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/logic/blocs/notes/notes_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/notes/notes.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/profile.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/upload/shared.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:papers_for_peers/presentation/modules/login/utilities.dart';
import 'package:provider/provider.dart';

class UploadNotes extends StatefulWidget {

  final String selectedSubject;

  const UploadNotes({
    required this.selectedSubject,
  });

  @override
  _UploadNotesState createState() => _UploadNotesState();
}

class _UploadNotesState extends State<UploadNotes> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {

    context.read<NotesBloc>().add(NotesAddEdit(
      title: null,
      subject: widget.selectedSubject,
      description: null,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final NotesState notesState = context.select((NotesBloc bloc) => bloc.state);

    print("NOTES STATE: ${notesState}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Notes",
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Builder(
                builder: (context) {

                  if (notesState is NotesAddEditing) {
                    return SizedBox(
                      height: 200,
                      child: getAddPostContainer(
                        isDarkTheme: appThemeType.isDarkTheme(),
                        label: notesState.file == null ? "Select File" : "File Selected: ${notesState.file!.path.split("/").last}",
                        onPressed: () {
                          context.read<NotesBloc>().add(NotesAddEdit(
                            title: notesState.title, description: notesState.description,
                            subject: widget.selectedSubject, isFileEdit: true,
                          ));
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
              ),
              SizedBox(height: 30,),

              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      getCustomTextField(
                        labelText: 'Title',
                        onChanged: (val) {
                          if (notesState is NotesAddEditing) {
                            context.read<NotesBloc>().add(NotesAddEdit(
                                title: val, description: notesState.description, subject: widget.selectedSubject
                            ));
                          }
                        },
                        validator: (String? val) => val!.isNotEmpty ? null : "Please enter title",
                      ),
                      SizedBox(height: 30,),
                      getCustomTextField(
                        labelText: 'Description',
                        onChanged: (val) {
                          if (notesState is NotesAddEditing) {
                            context.read<NotesBloc>().add(NotesAddEdit(
                                title: notesState.title, description: val, subject: widget.selectedSubject
                            ));
                          }
                        },
                        validator: (String? val) => val!.isNotEmpty ? null : "Please enter Description",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50,),
              getUploadButton(onPressed: () {
                if(_formKey.currentState!.validate()) {

                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
