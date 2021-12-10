import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/document_models/journal_model.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/data/repositories/firebase_remote_config/firebase_remote_config_repository.dart';
import 'package:papers_for_peers/logic/blocs/journal/journal_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/skeleton_loader.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

extension ToSubjectExtension on String {

  String toTitleCase() {

    if (this.length <= 1) {
      return this.toUpperCase();
    }
    final List<String> words = this.split(' ');

    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    return capitalizedWords.join(' ');
  }

  Text toSubjectText() {
    return Text(this.replaceAll("_", " ").toTitleCase(), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500));
  }
}

class Journal extends StatelessWidget {

  final DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  Widget _getJournalVariantDetailsTile({
    required int nVariant, required DateTime uploadedOn,
    required String uploadedBy, required Function() onTap,
    required AppThemeType appThemeType, required String? profilePhotoUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(dateFormat.format(uploadedOn), style: TextStyle(fontSize: 12),),
            SizedBox(height: 5,),
            Text("Variant $nVariant", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),),

            SizedBox(height: 10,),

            Row(
              children: [
                Utils.getProfilePhotoWidget(url: profilePhotoUrl, username: uploadedBy, radius: 15, fontSize: 14),
                SizedBox(width: 10,),
                Expanded(
                  child: AutoSizeText(
                    uploadedBy,
                    style: TextStyle(fontSize: 14),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getJournalTile({
    required String subject, required List<JournalModel> journals,
    required AppThemeType appThemeType, required UserState userState,
    required bool isAddJournalLoading, required bool isWidgetLoading,
    required BuildContext context, required List<JournalSubjectModel> journalSubjects,
    required int maxJournals,
  }) {

    List<Widget> children = List.generate(journals.length, (index) {
      JournalModel currentJournalModel = journals[index];
      return _getJournalVariantDetailsTile(
          appThemeType: appThemeType,
          profilePhotoUrl: currentJournalModel.userProfilePhotoUrl,
          uploadedBy: currentJournalModel.uploadedBy,
          uploadedOn: currentJournalModel.uploadedOn,
          nVariant: index+1,
          onTap: isWidgetLoading ? () {} : () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PDFViewerScreen<PDFScreenSimpleBottomSheet>(
                onReportPressed: (values) {
                  if (userState is UserLoaded) {
                    context.read<JournalBloc>().add(JournalReportAdd(
                      reportValues: values,
                      journalSubjects: journalSubjects,
                      uploadedBy: userState.userModel.displayName!,
                      course: userState.userModel.course!.courseName!,
                      semester: userState.userModel.semester!.nSemester!,
                      subject: subject,
                      journalId: currentJournalModel.id,
                      user: userState.userModel,
                    ));
                  }
                },
                documentUrl: currentJournalModel.documentUrl,
                screenLabel: "Journal",
                parameter: PDFScreenSimpleBottomSheet(
                  profilePhotoUrl: currentJournalModel.userProfilePhotoUrl,
                  nVariant: index+1,
                  uploadedBy: currentJournalModel.uploadedBy,
                  title: subject,
                ),
              ),
            ));
          }
      );
    });

    if (journals.length < maxJournals) {
      children.add(Utils.getAddPostContainer(
        isDarkTheme: appThemeType.isDarkTheme(),
        onPressed: isAddJournalLoading || isWidgetLoading ? () {} : () {
          if (userState is UserLoaded) {
            context.read<JournalBloc>().add(JournalAdd(
              journalSubjects: journalSubjects,
              uploadedBy: userState.userModel.displayName!,
              course: userState.userModel.course!.courseName!,
              semester: userState.userModel.semester!.nSemester!,
              subject: subject,
              user: userState.userModel,
            ));
          }
        },
        label: isAddJournalLoading ? "Loading" : "Add Journal",
      ));
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subject.toSubjectText(),
          SizedBox(height: 20,),
          GridView.count(
            crossAxisSpacing: 10,
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 16/10,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _getJournalListWidget({
    required UserState userState,
    required List<JournalSubjectModel> journalSubjects,
    required AppThemeType appThemeType,
    required bool isAddJournalLoading,
    bool isWidgetLoading = false,
    required int maxJournals,
  }) {

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 20,),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: journalSubjects.length,
      itemBuilder: (context, journalSubjectIndex) {
        return _getJournalTile(
          maxJournals: maxJournals,
          isWidgetLoading: isWidgetLoading,
          journalSubjects: journalSubjects,
          context: context,
          isAddJournalLoading: isAddJournalLoading,
          journals: journalSubjects[journalSubjectIndex].journalModels,
          subject: journalSubjects[journalSubjectIndex].subject,
          appThemeType: appThemeType,
          userState: userState,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final UserState userState = context.select((UserCubit cubit) => cubit.state);
    final JournalState journalState = context.watch<JournalBloc>().state;

    if (journalState is JournalInitial) {
      if (userState is UserLoaded)
      context.read<JournalBloc>().add(
          JournalFetch(
            course: userState.userModel.course!.courseName!,
            semester: userState.userModel.semester!.nSemester!,
          )
      );
    }

    return BlocListener<JournalBloc, JournalState>(
      listener: (context, state) {
        if (state is JournalFetchError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        } else if (state is JournalAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        } else if (state is JournalAddSuccess) {
          Utils.showAlertDialog(context: context, text: "Journal Successfully Submitted");
        } else if (state is JournalReportSuccess) {
          Utils.showAlertDialog(context: context, text: "Journal Reported Successfully");
        } else if (state is JournalReportError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: RefreshIndicator(
          onRefresh: () async {
            if (userState is UserLoaded) {
              context.read<JournalBloc>().add(
                  JournalFetch(
                    course: userState.userModel.course!.courseName!,
                    semester: userState.userModel.semester!.nSemester!,
                  )
              );
            }
          },
          child: ListView(
            children: [
              SizedBox(height: 20,),

              Builder(
                  builder: (context) {
                    if (userState is UserLoaded) {
                      return Utils.getCourseAndSemesterText(context: context,);
                    } else {
                      return Center(child: CircularProgressIndicator.adaptive(),);
                    }
                  }
              ),

              SizedBox(height: 20,),

              Builder(
                  builder: (context) {
                    if (journalState is JournalFetchLoading) {
                      return SkeletonLoader(
                        appThemeType: appThemeType,
                        child: _getJournalListWidget(
                          maxJournals: journalState.maxJournals,
                          isWidgetLoading: true,
                          userState: userState,
                          journalSubjects: List.generate(3, (index) => JournalSubjectModel(
                            subject: "",
                            journalModels: List.generate(2, (index) => JournalModel(
                              documentUrl: "",
                              uploadedOn: DateTime.now(),
                              userEmail: "",
                              userProfilePhotoUrl: "",
                              userUid: "",
                              uploadedBy: "",
                              id: '',
                            )),
                          )),
                          appThemeType: appThemeType,
                          isAddJournalLoading: false,
                        ),
                      );
                    } else if (journalState is JournalFetchSuccess) {
                      return _getJournalListWidget(
                        maxJournals: journalState.maxJournals,
                        userState: userState,
                        journalSubjects: journalState.journalSubjects,
                        appThemeType: appThemeType,
                        isAddJournalLoading: false,
                      );
                    } else if (journalState is JournalAddError) {
                      return _getJournalListWidget(
                        maxJournals: journalState.maxJournals,
                        userState: userState,
                        journalSubjects: journalState.journalSubjects,
                        appThemeType: appThemeType,
                        isAddJournalLoading: false,
                      );
                    } else if (journalState is JournalAddSuccess) {
                      return _getJournalListWidget(
                        maxJournals: journalState.maxJournals,
                        userState: userState,
                        journalSubjects: journalState.journalSubjects,
                        appThemeType: appThemeType,
                        isAddJournalLoading: false,
                      );
                    } else if (journalState is JournalAddLoading) {
                      return _getJournalListWidget(
                        maxJournals: journalState.maxJournals,
                        userState: userState,
                        journalSubjects: journalState.journalSubjects,
                        appThemeType: appThemeType,
                        isAddJournalLoading: true,
                      );
                    } else {
                      return Center(child: CircularProgressIndicator.adaptive(),);
                    }
                  }
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
