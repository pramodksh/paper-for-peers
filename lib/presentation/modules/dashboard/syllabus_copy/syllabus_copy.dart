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
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
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
            itemCount: syllabusCopies.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PDFViewerScreen<PDFScreenSyllabusCopy>(
                      documentUrl: syllabusCopies[index].documentUrl,
                      screenLabel: "Syllabus Copy",
                      isShowBottomSheet: false,
                      parameter: PDFScreenSyllabusCopy(
                        uploadedBy: syllabusCopies[index].uploadedBy,
                        nVariant: syllabusCopies[index].version,
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
                  child: Text("Variant: ${syllabusCopies[index].version}", style: TextStyle(fontSize: 20),),
                ),
              );
            },
          ),

          SizedBox(height: 20,),

          Builder(
              builder: (context) {
                if (syllabusCopies.length < AppConstants.maxSyllabusCopy) {
                  return SizedBox(
                    height: 100,
                    child: getAddPostContainer(
                      isDarkTheme: isDarkTheme,
                      label: syllabusCopyState is SyllabusCopyAddLoading ? "Loading" : "Add Syllabus Copy",
                      onPressed: syllabusCopyState is SyllabusCopyAddLoading || isWidgetLoading ? () {} :  () {
                        if (userState is UserLoaded) {
                          context.read<SyllabusCopyBloc>().add(SyllabusCopyAdd(
                            syllabusCopies: syllabusCopies,
                            version: syllabusCopies.length + 1,
                            user: userState.userModel,
                          ));
                        }
                      },
                    ),
                  );
                } else {
                  return Container();
                }


              }
          )

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
          showAlertDialog(context: context, text: state.errorMessage);
        }
        if (state is SyllabusCopyAddSuccess) {
          showAlertDialog(context: context, text: "Syllabus Copy successfully updated");
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
