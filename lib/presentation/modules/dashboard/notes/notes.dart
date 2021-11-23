import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/data/models/document_models/notes_model.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/notes/notes_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/notes/upload_notes.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/skeleton_loader.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/post_tiles.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';

class Notes extends StatelessWidget {

  Widget _getNotesListWidget({
    required List<NotesModel> notes, bool isWidgetLoading = false,
    required NotesState notesState, required UserState userState,
    required AppThemeType appThemeType, required BuildContext context,
  }) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
                  documentUrl: notes[index].documentUrl,
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
            onPressed: isWidgetLoading ? () {} : () async {

              if (userState is UserLoaded) {
                bool? isRefresh = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UploadNotes(
                    notes: notes,
                    selectedSubject: notesState.selectedSubject!,
                    user: userState.userModel,
                  ),
                ));
              }

            },
            label: "Add Notes",
          ),
        ) : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final UserState userState = context.select((UserCubit cubit) => cubit.state);
    // final NotesState notesState = context.select((NotesBloc bloc) => bloc.state);
    final NotesState notesState = context.watch<NotesBloc>().state;
    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesFetchError) {
          showAlertDialog(context: context, text: state.errorMessage);
        }
        if (state is NotesAddError) {
          showAlertDialog(context: context, text: state.errorMessage);
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: RefreshIndicator(
            onRefresh: notesState.selectedSubject == null ? () async {
              showAlertDialog(context: context, text: "Select subject to refresh");
            } : () async {
              if (userState is UserLoaded) {
                context.read<NotesBloc>().add(
                    NotesFetch(
                        course: userState.userModel.course!.courseName!,
                        semester: userState.userModel.semester!.nSemester!,
                        subject: notesState.selectedSubject!
                    )
                );
              }
            },
            child: ListView(
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
                      return SkeletonLoader(
                        appThemeType: appThemeType,
                        child: _getNotesListWidget(
                          context: context,
                          appThemeType: appThemeType,
                          userState: userState,
                          notesState: notesState,
                          isWidgetLoading: true,
                          notes: List.generate(3, (index) => NotesModel(
                            uploadedBy: "",
                            userUid: "",
                            userProfilePhotoUrl: "",
                            userEmail: "",
                            uploadedOn: DateTime.now(),
                            documentUrl: "",
                            title: "",
                            description: "",
                            rating: 0,
                          ),),
                        ),
                      );
                    } else if (notesState is NotesFetchSuccess) {
                      return _getNotesListWidget(
                        notes: notesState.notes, notesState: notesState, userState: userState,
                        appThemeType: appThemeType, context: context,
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
