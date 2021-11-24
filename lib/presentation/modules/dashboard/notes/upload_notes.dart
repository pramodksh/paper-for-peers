import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/data/models/document_models/notes_model.dart';
import 'package:papers_for_peers/data/models/user_model/user_model.dart';
import 'package:papers_for_peers/logic/blocs/notes/notes_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/profile/upload/shared.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class UploadNotes extends StatefulWidget {

  final String selectedSubject;
  final UserModel user;
  final List<NotesModel> notes;

  @override
  _UploadNotesState createState() => _UploadNotesState();

  const UploadNotes({
    required this.selectedSubject,
    required this.user,
    required this.notes,
  });
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

  Widget _getSelectFileWidget({required AppThemeType appThemeType, required Function() onPressed, required File? file}) {
    return SizedBox(
      height: 200,
      child: Utils.getAddPostContainer(
        isDarkTheme: appThemeType.isDarkTheme(),
        label: file == null ? "Select File" : "File Selected: ${file.path.split("/").last}",
        onPressed: onPressed,
      ),
    );
  }

  void resetNotesState({required BuildContext context, required String selectedSubject, required List<NotesModel> notes}) {
    context.read<NotesBloc>().add(NotesResetToNotesFetch(
      selectedSubject: selectedSubject,
      notes: notes,
    ));
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final NotesState notesState = context.select((NotesBloc bloc) => bloc.state);

    print("NOTES STATE: ${notesState}");

    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
          context.read<NotesBloc>().add(NotesAddEdit(
              title: state.title, description: state.description, subject: state.selectedSubject!,
          ));
        }

        if (state is NotesAddSuccess) {
          Utils.showAlertDialog(context: context, text: "Successfully uploaded").then((value) {
            resetNotesState(context: context, selectedSubject: state.selectedSubject!, notes: widget.notes);
            Navigator.of(context).pop();
          });
        }

      },
      child: WillPopScope(
        onWillPop: () async {
          resetNotesState(context: context, selectedSubject: notesState.selectedSubject!, notes: widget.notes);
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Upload Notes",
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Builder(
                  builder: (context) {
                    if (notesState is NotesAddLoading) {
                      return Center(child: CircularProgressIndicator.adaptive(),);
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              if (notesState is NotesAddEditing) {
                                return _getSelectFileWidget(
                                    appThemeType: appThemeType,
                                    file: notesState.file,
                                    onPressed: () {
                                      context.read<NotesBloc>().add(NotesAddEdit(
                                        title: notesState.title, description: notesState.description,
                                        subject: widget.selectedSubject, isFileEdit: true,
                                      ));
                                    }
                                );
                              } else if (notesState is NotesAddError) {
                                return _getSelectFileWidget(
                                    appThemeType: appThemeType,
                                    file: notesState.file,
                                    onPressed: () {
                                      context.read<NotesBloc>().add(NotesAddEdit(
                                        title: notesState.title, description: notesState.description,
                                        subject: widget.selectedSubject, isFileEdit: true,
                                      ));
                                    }
                                );
                              } else if (notesState is NotesAddSuccess) {
                                return _getSelectFileWidget(
                                    appThemeType: appThemeType,
                                    file: notesState.file,
                                    onPressed: () {
                                      context.read<NotesBloc>().add(NotesAddEdit(
                                        title: notesState.title, description: notesState.description,
                                        subject: widget.selectedSubject, isFileEdit: true,
                                      ));
                                    }
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
                                  Utils.getCustomTextField(
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
                                  Utils.getCustomTextField(
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
                              if (notesState is NotesAddEditing)
                              context.read<NotesBloc>().add(NotesAdd(
                                file: notesState.file,
                                title: notesState.title!,
                                description: notesState.description!,
                                subject: widget.selectedSubject,
                                user: widget.user,
                              ));
                            }
                          }),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
      ),
    );
  }
}
