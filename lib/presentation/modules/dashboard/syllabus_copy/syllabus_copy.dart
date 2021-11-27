import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/document_models/syllabus_copy.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/syllabus_copy/syllabus_copy_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/skeleton_loader.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';

class SyllabusCopy extends StatelessWidget {

  Widget _getSyllabusCopyListWidget({
    required List<SyllabusCopyModel> syllabusCopies,
    required bool isDarkTheme,
    required UserState userState,
    required SyllabusCopyState syllabusCopyState,
    bool isWidgetLoading = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(height: 30,),
          Text("Syllabus Copy", style: TextStyle(fontSize: 25),),
          SizedBox(height: 20,),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: AppConstants.maxSyllabusCopy,
            itemBuilder: (context, index) {
              int currentVersion = index + 1;
              bool isShow = syllabusCopies.any((element) => element.version == currentVersion);

              if (isShow) {
                SyllabusCopyModel currentSyllabusCopyModel = syllabusCopies.firstWhere((element) => element.version == currentVersion);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PDFViewerScreen<PDFScreenSyllabusCopy>(
                        onReportPressed: (values) {
                          print("VALUES: ${values}");
                          // todo syllabus copy report
                        },
                        documentUrl: currentSyllabusCopyModel.documentUrl,
                        screenLabel: "Syllabus Copy",
                        isShowBottomSheet: false,
                        parameter: PDFScreenSyllabusCopy(
                          uploadedBy: currentSyllabusCopyModel.uploadedBy,
                          nVariant: currentSyllabusCopyModel.version,
                        ),
                      ),
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    decoration: BoxDecoration(
                      color: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("Variant: ${currentSyllabusCopyModel.version}", style: TextStyle(fontSize: 20),),
                  ),
                );
              } else {
                return SizedBox(
                  height: 100,
                  child: Utils.getAddPostContainer(
                    isDarkTheme: isDarkTheme,
                    label: syllabusCopyState is SyllabusCopyAddLoading ? "Loading" : "Add Syllabus Copy",
                    onPressed: syllabusCopyState is SyllabusCopyAddLoading || isWidgetLoading ? () {} :  () {
                      if (userState is UserLoaded) {
                        context.read<SyllabusCopyBloc>().add(SyllabusCopyAdd(
                          syllabusCopies: syllabusCopies,
                          version: currentVersion,
                          user: userState.userModel,
                        ));
                      }
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    final UserState userState = context.select((UserCubit cubit) => cubit.state);
    final SyllabusCopyState syllabusCopyState = context.watch<SyllabusCopyBloc>().state;
    final AppThemeState appThemeState = context.watch<AppThemeCubit>().state;

    if (syllabusCopyState is SyllabusCopyInitial) {
      if (userState is UserLoaded)
      context.read<SyllabusCopyBloc>().add(SyllabusCopyFetch(
        course: userState.userModel.course!.courseName!,
        semester: userState.userModel.semester!.nSemester!,
      ));
    }

    return BlocListener<SyllabusCopyBloc, SyllabusCopyState>(
      listener: (context, state) {
        if (state is SyllabusCopyAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        }
        if (state is SyllabusCopyAddSuccess) {
          Utils.showAlertDialog(context: context, text: "Syllabus Copy successfully updated");
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (userState is UserLoaded) {
            context.read<SyllabusCopyBloc>().add(SyllabusCopyFetch(
              course: userState.userModel.course!.courseName!,
              semester: userState.userModel.semester!.nSemester!,
            ));
          }
        },
        child: ListView(
          children: [
            Builder(
              builder: (context) {
                if (syllabusCopyState is SyllabusCopyFetchLoading) {
                  return SkeletonLoader(
                    appThemeType: appThemeState.appThemeType,
                    child: _getSyllabusCopyListWidget(
                      syllabusCopies: List.generate(2, (index) => SyllabusCopyModel(
                        version: index,
                        uploadedBy: "",
                        userUid: "",
                        userProfilePhotoUrl: "",
                        userEmail: "",
                        uploadedOn: DateTime.now(),
                        documentUrl: "",
                      )),
                      isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                      userState: userState,
                      syllabusCopyState: syllabusCopyState,
                    ),
                  );
                } else if (syllabusCopyState is SyllabusCopyAddLoading) {
                  List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
                  return _getSyllabusCopyListWidget(
                    syllabusCopies: syllabusCopies,
                    isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                    userState: userState,
                    syllabusCopyState: syllabusCopyState,
                  );
                } else if (syllabusCopyState is SyllabusCopyFetchSuccess) {
                  List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
                  return _getSyllabusCopyListWidget(
                    syllabusCopies: syllabusCopies,
                    isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                    userState: userState,
                    syllabusCopyState: syllabusCopyState,
                  );
                } else if (syllabusCopyState is SyllabusCopyAddError) {
                  List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
                  return _getSyllabusCopyListWidget(
                    syllabusCopies: syllabusCopies,
                    isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                    userState: userState,
                    syllabusCopyState: syllabusCopyState,
                  );
                } else if (syllabusCopyState is SyllabusCopyAddSuccess) {
                  List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
                  return _getSyllabusCopyListWidget(
                    syllabusCopies: syllabusCopies,
                    isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                    userState: userState,
                    syllabusCopyState: syllabusCopyState,
                  );
                } else {
                  return Center(child: CircularProgressIndicator.adaptive(),);
                }

              },
            ),
          ],
        ),
      ),
    );
  }
}
