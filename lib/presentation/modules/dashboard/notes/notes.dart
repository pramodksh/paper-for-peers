import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/document_models/notes_model.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/notes/notes_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/notes/upload_notes.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/skeleton_loader.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class Notes extends StatelessWidget {

  Widget _getNotesDetailsTile({
    required String title,
    required String description,
    required String? profilePhotoUrl,
    required double rating,
    required onTileTap,
    required BuildContext context,
    required AppThemeType appThemeType,
    String? uploadedBy,
    DateTime? uploadedOn,
    bool isYourPostTile = false,
    Function()? yourPostTileOnDelete,
    bool isDeleteButtonLoading = false,
  }) {

    DateFormat dateFormat = DateFormat("dd MMMM yyyy");

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
                  color: appThemeType.isDarkTheme() ? CustomColors.ratingBackgroundColor : CustomColors.lightModeRatingBackgroundColor,
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
                  color: appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
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
                            Utils.getProfilePhotoWidget(url: profilePhotoUrl, username: uploadedBy!),
                            SizedBox(width: 10,),
                            Text(uploadedBy, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateFormat.format(uploadedOn!)),

                            Builder(
                              builder: (context) {
                                if (isYourPostTile) {
                                  if (isDeleteButtonLoading) {
                                    return CircularProgressIndicator.adaptive();
                                  } else {
                                    return ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20))
                                      ),
                                      onPressed: yourPostTileOnDelete,
                                      child: Text("Delete", style: TextStyle(fontSize: 16),),
                                    );
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            ),
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

  Widget _getNotesListWidget({
    required List<NotesModel> notes, bool isWidgetLoading = false,
    required NotesState notesState, required UserState userState,
    required AppThemeType appThemeType, required BuildContext context,
    bool isDeleteButtonLoading = false,
  }) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) => _getNotesDetailsTile(
            profilePhotoUrl: notes[index].userProfilePhotoUrl,
            isDeleteButtonLoading: isDeleteButtonLoading,
            isYourPostTile: (userState as UserLoaded).userModel.uid == notes[index].userUid,
            yourPostTileOnDelete: () {
              context.read<NotesBloc>().add(NotesDelete(
                notes: notes,
                subject: notesState.selectedSubject!,
                semester: userState.userModel.semester!.nSemester!,
                course: userState.userModel.course!.courseName!,
                noteId: notes[index].noteId,
              ));
            },
            context: context,
            appThemeType: appThemeType,
            onTileTap: () async {
              Map<String, dynamic> ratingDetails = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PDFViewerScreen<PDFScreenNotesBottomSheet>(
                  onReportPressed: (values) {
                    if (userState is UserLoaded) {
                      context.read<NotesBloc>().add(NotesReportAdd(
                        notes: notes,
                        reportValues: values,
                        user: userState.userModel,
                        noteId: notes[index].noteId,
                        subject: notesState.selectedSubject!,
                        semester: userState.userModel.semester!.nSemester!,
                        course: userState.userModel.course!.courseName!,
                      ));
                    }
                  },
                  documentUrl: notes[index].documentUrl,
                  screenLabel: "Notes",
                  parameter: PDFScreenNotesBottomSheet(
                    profilePhotoUrl: notes[index].userProfilePhotoUrl,
                    rating: notes[index].rating,
                    uploadedBy: notes[index].uploadedBy,
                    description: notes[index].description,
                    title: notes[index].title,
                  ),
                ),
              ));

              bool isRatingChanged = ratingDetails['isRatingChanged'];
              if (isRatingChanged) {
                double rating = ratingDetails['rating'];
                if (userState is UserLoaded) {
                  context.read<NotesBloc>().add(NotesRatingChanged(
                    ratingAcceptedUserId: notes[index].userUid,
                    ratingGivenUser: userState.userModel,
                    rating: rating,
                    noteId: notes[index].noteId,
                    subject: notesState.selectedSubject!,
                    semester: userState.userModel.semester!.nSemester!,
                    course: userState.userModel.course!.courseName!,
                  ));
                }
              }
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
          child: Utils.getAddPostContainer(
            isDarkTheme: appThemeType.isDarkTheme(),
            onPressed: isWidgetLoading ? () {} : () async {

              if (userState is UserLoaded) {
                Navigator.of(context).push(MaterialPageRoute(
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
    final NotesState notesState = context.watch<NotesBloc>().state;

    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesFetchError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        } else if (state is NotesAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        } else if (state is NotesReportAddSuccess) {
          Utils.showAlertDialog(context: context, text: "Note was reported successfully");
        } else if (state is NotesReportAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        } else if (state is NotesDeleteSuccess) {
          Utils.showAlertDialog(context: context, text: "Note was deleted successfully");
        } else if (state is NotesDeleteError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: RefreshIndicator(
            onRefresh: notesState.selectedSubject == null ? () async {
              Utils.showAlertDialog(context: context, text: "Select subject to refresh");
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
                            Expanded(flex: 2,child: Utils.getCourseAndSemesterText(context: context,)),
                            Expanded(
                              flex: 3,
                              child: Utils.getCustomDropDown<String>(
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
                            noteId: "",
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
                    } else if (notesState is NotesDeleteLoading) {
                      return _getNotesListWidget(
                        isDeleteButtonLoading: true,
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
