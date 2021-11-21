import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/data/models/document_models/notes_model.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/notes/notes_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/notes/upload_notes.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/post_tiles.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  final bool isDarkTheme;

  Notes({required this.isDarkTheme});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final UserState userState = context.select((UserCubit cubit) => cubit.state);
    final NotesState notesState = context.select((NotesBloc bloc) => bloc.state);

    // todo remove scaffold if possible
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Builder(
                  builder: (context) {
                    if (userState is UserLoaded) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2,child: getCourseAndSemesterText(context: context,)),
                          Expanded(
                            flex: 3,
                            child: getCustomDropDown<String>(
                              context: context,
                              dropDownHint: "Subject",
                              dropDownItems: userState.userModel.semester!.subjects,
                              dropDownValue: notesState.selectedSubject,
                              onDropDownChanged: (val) {
                                context.read<NotesBloc>().add(
                                  NotesFetch(
                                    course: userState.userModel.course!.courseName!,
                                    semester: userState.userModel.semester!.nSemester!,
                                    subject: val!
                                  )
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator.adaptive(),);
                    }
                  }
              ),
              SizedBox(height: 20,),
              Builder(
                builder: (context) {
                  if (notesState.selectedSubject == null) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(child: Text("Select Subject to Continue", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,)),
                    );
                  } else if (notesState is NotesFetchLoading) {
                    return Center(child: CircularProgressIndicator.adaptive(),);
                  } else if (notesState is NotesFetchSuccess) {
                    List<NotesModel> notes = notesState.notes;
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: notes.length,
                          itemBuilder: (context, index) => getNotesDetailsTile(
                            context: context,
                            appThemeType: appThemeType,
                            onTileTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PDFViewerScreen<PDFScreenNotesBottomSheet>(
                                  screenLabel: "Notes",
                                  parameter: PDFScreenNotesBottomSheet(
                                    rating: notes[index].rating,
                                    uploadedBy: notes[index].uploadedBy,
                                    description: notes[index].description,
                                    title: notes[index].title,
                                  ),
                                ),
                              ));
                            },
                            title: notes[index].title,
                            description: notes[index].description,
                            uploadedBy: notes[index].uploadedBy,
                            rating: notes[index].rating,
                            uploadedOn: notes[index].uploadedOn,
                          ),
                        ),
                        SizedBox(height: 20,),
                        notesState.selectedSubject != null ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: getAddPostContainer(
                            isDarkTheme: appThemeType.isDarkTheme(),
                            onPressed: () async {

                              if (userState is UserLoaded) {
                                bool? isRefresh = await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UploadNotes(
                                    selectedSubject: notesState.selectedSubject!,
                                    user: userState.userModel,
                                  ),
                                ));

                                if (isRefresh == true) {

                                }

                              }

                            },
                            label: "Add Notes",
                          ),
                        ) : Container(),
                      ],
                    );
                  } else if (notesState is NotesFetchError) {
                    return Container();
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
