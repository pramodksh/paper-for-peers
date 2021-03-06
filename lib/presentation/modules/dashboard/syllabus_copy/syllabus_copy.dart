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
    required int maxSyllabusCopy,
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

          Builder(
            builder: (context) {
              List<Widget> children = List.generate(syllabusCopies.length, (index) {
                SyllabusCopyModel currentSyllabusCopyModel = syllabusCopies[index];
                return GestureDetector(
                  onTap: isWidgetLoading ? () {} : () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PDFViewerScreen<PDFScreenSyllabusCopy>(
                        onReportPressed: (values) {
                          if (userState is UserLoaded) {
                            context.read<SyllabusCopyBloc>().add(SyllabusCopyReportAdd(
                              reportValues: values,
                              syllabusCopies: syllabusCopies,
                              syllabusCopyId: currentSyllabusCopyModel.id,
                              user: userState.userModel,
                            ));
                          }
                        },
                        documentUrl: currentSyllabusCopyModel.documentUrl,
                        screenLabel: "Syllabus Copy",
                        isShowBottomSheet: false,
                        parameter: PDFScreenSyllabusCopy(
                          profilePhotoUrl: currentSyllabusCopyModel.userProfilePhotoUrl,
                          uploadedBy: currentSyllabusCopyModel.uploadedBy,
                          nVariant: index+1,
                        ),
                      ),
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    decoration: BoxDecoration(
                      color: isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("Variant: ${index+1}", style: TextStyle(fontSize: 20),),
                  ),
                );
              });

              if (syllabusCopies.length < maxSyllabusCopy) {
                children.add(SizedBox(
                  height: 100,
                  child: Utils.getAddPostContainer(
                    isDarkTheme: isDarkTheme,
                    label: syllabusCopyState is SyllabusCopyAddLoading ? "Loading" : "Add Syllabus Copy",
                    onPressed: syllabusCopyState is SyllabusCopyAddLoading || isWidgetLoading ? () {} :  () {
                      if (userState is UserLoaded) {
                        context.read<SyllabusCopyBloc>().add(SyllabusCopyAdd(
                          syllabusCopies: syllabusCopies,
                          user: userState.userModel,
                        ));
                      }
                    },
                  ),
                ));
              }

              return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 20,),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: children.length,
                itemBuilder: (context, index) => children[index],
              );
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
        } else if (state is SyllabusCopyAddSuccess) {
          Utils.showAlertDialog(context: context, text: "Syllabus Copy Successfully Submitted");
        } else if (state is SyllabusCopyReportSuccess) {
          Utils.showAlertDialog(context: context, text: "Syllabus Copy reported successfully");
        } else if (state is SyllabusCopyReportError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
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
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Utils.getCourseAndSemesterText(context: context),
            ),
            Builder(
              builder: (context) {
                if (syllabusCopyState is SyllabusCopyFetchLoading) {
                  return SkeletonLoader(
                    appThemeType: appThemeState.appThemeType,
                    child: _getSyllabusCopyListWidget(
                      maxSyllabusCopy: syllabusCopyState.maxSyllabusCopy,
                      isWidgetLoading: true,
                      syllabusCopies: List.generate(2, (index) => SyllabusCopyModel(
                        id: '',
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
                    maxSyllabusCopy: syllabusCopyState.maxSyllabusCopy,
                    syllabusCopies: syllabusCopies,
                    isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                    userState: userState,
                    syllabusCopyState: syllabusCopyState,
                  );
                } else if (syllabusCopyState is SyllabusCopyFetchSuccess) {
                  List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
                  return _getSyllabusCopyListWidget(
                    maxSyllabusCopy: syllabusCopyState.maxSyllabusCopy,
                    syllabusCopies: syllabusCopies,
                    isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                    userState: userState,
                    syllabusCopyState: syllabusCopyState,
                  );
                } else if (syllabusCopyState is SyllabusCopyAddError) {
                  List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
                  return _getSyllabusCopyListWidget(
                    maxSyllabusCopy: syllabusCopyState.maxSyllabusCopy,
                    syllabusCopies: syllabusCopies,
                    isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                    userState: userState,
                    syllabusCopyState: syllabusCopyState,
                  );
                } else if (syllabusCopyState is SyllabusCopyAddSuccess) {
                  List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
                  return _getSyllabusCopyListWidget(
                    maxSyllabusCopy: syllabusCopyState.maxSyllabusCopy,
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
