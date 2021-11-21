import 'package:flutter/material.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/document_models/syllabus_copy.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/syllabus_copy/syllabus_copy_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';

class SyllabusCopy extends StatefulWidget {
  @override
  _SyllabusCopyState createState() => _SyllabusCopyState();
}

class _SyllabusCopyState extends State<SyllabusCopy> {
  @override
  Widget build(BuildContext context) {

    final UserState userState = context.select((UserCubit cubit) => cubit.state);
    final SyllabusCopyState syllabusCopyState = context.select((SyllabusCopyBloc bloc) => bloc.state);
    AppThemeState appThemeState = context.watch<AppThemeCubit>().state;

    print("STATE: ${syllabusCopyState}");

    if (syllabusCopyState is SyllabusCopyInitial) {
      if (userState is UserLoaded)
      context.read<SyllabusCopyBloc>().add(SyllabusCopyFetch(
        course: userState.userModel.course!.courseName!,
        semester: userState.userModel.semester!.nSemester!,
      ));
    }

    return Scaffold(
      body: Builder(
        builder: (context) {

          if (syllabusCopyState is SyllabusCopyFetchLoading) {
            return Center(child: CircularProgressIndicator.adaptive(),);
          } else if (syllabusCopyState is SyllabusCopyFetchSuccess) {
            List<SyllabusCopyModel> syllabusCopies = syllabusCopyState.syllabusCopies;
            return Column(
              children: [
                SizedBox(height: 30,),
                Text("Syllabus Copy", style: TextStyle(fontSize: 25),),
                SizedBox(height: 20,),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  itemCount: syllabusCopies.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PDFViewerScreen<PDFScreenSyllabusCopy>(
                            documentUrlArg: syllabusCopies[index].url,
                            screenLabel: "Syllabus Copy",
                            isShowBottomSheet: false,
                            parameter: PDFScreenSyllabusCopy(
                              uploadedBy: syllabusCopies[index].uploadedBy,
                              nVariant: 1,
                              totalVariants: 1,
                            ),
                          ),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        decoration: BoxDecoration(
                          color: appThemeState.appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text("Variant: ${syllabusCopies[index].version}", style: TextStyle(fontSize: 20),),
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    height: 100,
                    child: getAddPostContainer(
                      isDarkTheme: appThemeState.appThemeType.isDarkTheme(),
                      label: "Add Syllabus Copy",
                      onPressed: () {

                      },
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator.adaptive(),);
          }

        },
      ),
    );
  }
}
