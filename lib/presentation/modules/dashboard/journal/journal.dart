import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/document_models/journal_model.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/journal/journal_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/skeleton_loader.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';


class Journal extends StatelessWidget {

  final DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  Widget _getJournalVariantDetailsTile({
    required int nVariant, required DateTime uploadedOn,
    required String uploadedBy, required Function() onTap,
    required AppThemeType appThemeType,
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
                CircleAvatar(
                  child: FlutterLogo(),
                  radius: 15,
                ),
                SizedBox(width: 10,),
                Text(uploadedBy, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
    required bool isAddJournalLoading,
    required BuildContext context, required List<JournalSubjectModel> journalSubjects
  }) {

    List<Widget> gridChildren = List.generate(AppConstants.maxJournals, (index) {
      int currentVersion = index + 1;
      bool isShow = journals.any((element) => element.version == currentVersion);

      if (isShow) {
        JournalModel currentJournalModel = journals.firstWhere((element) => element.version == currentVersion);
        return _getJournalVariantDetailsTile(
          appThemeType: appThemeType,
          uploadedBy: currentJournalModel.uploadedBy,
          uploadedOn: currentJournalModel.uploadedOn,
          nVariant: currentVersion,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PDFViewerScreen<PDFScreenSimpleBottomSheet>(
                onReportPressed: (values) {
                  print("VALUES: ${values}");
                  // todo journal report
                },
                documentUrl: currentJournalModel.documentUrl,
                screenLabel: "Journal",
                parameter: PDFScreenSimpleBottomSheet(
                    nVariant: currentVersion,
                    uploadedBy: currentJournalModel.uploadedBy,
                    title: subject
                ),
              ),
            ));
          }
        );
      } else {
       return Utils.getAddPostContainer(
         isDarkTheme: appThemeType.isDarkTheme(),
         onPressed: isAddJournalLoading ? () {} : () {
           if (userState is UserLoaded) {
             context.read<JournalBloc>().add(JournalAdd(
               journalSubjects: journalSubjects,
               uploadedBy: userState.userModel.displayName!,
               course: userState.userModel.course!.courseName!,
               semester: userState.userModel.semester!.nSemester!,
               subject: subject,
               nVersion: currentVersion,
               user: userState.userModel,
             ));
           }
         },
         label: isAddJournalLoading ? "Loading" : "Add Journal",
       );
      }
    });

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),),
          SizedBox(height: 20,),
          GridView.count(
            crossAxisSpacing: 10,
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 16/10,
            children: gridChildren,
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
  }) {

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 20,),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: journalSubjects.length,
      itemBuilder: (context, journalSubjectIndex) {
        return _getJournalTile(
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
        }
        if (state is JournalAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        }
        if (state is JournalAddSuccess) {
          Utils.showAlertDialog(context: context, text: "Journal Added Successfully");
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
                              version: index,
                            )),
                          )),
                          appThemeType: appThemeType,
                          isAddJournalLoading: false,
                        ),
                      );
                    } else if (journalState is JournalFetchSuccess) {
                      return _getJournalListWidget(
                        userState: userState,
                        journalSubjects: journalState.journalSubjects,
                        appThemeType: appThemeType,
                        isAddJournalLoading: false,
                      );
                    } else if (journalState is JournalAddError) {
                      return _getJournalListWidget(
                        userState: userState,
                        journalSubjects: journalState.journalSubjects,
                        appThemeType: appThemeType,
                        isAddJournalLoading: false,
                      );
                    } else if (journalState is JournalAddSuccess) {
                      return _getJournalListWidget(
                        userState: userState,
                        journalSubjects: journalState.journalSubjects,
                        appThemeType: appThemeType,
                        isAddJournalLoading: false,
                      );
                    } else if (journalState is JournalAddLoading) {
                      return _getJournalListWidget(
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
            ],
          ),
        ),
      ),
    );
  }
}
