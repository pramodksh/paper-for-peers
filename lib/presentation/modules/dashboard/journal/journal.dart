import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/journal/journal_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';


class Journal extends StatefulWidget {
  final bool isDarkTheme;

  Journal({required this.isDarkTheme});

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {

  DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  void onAddJournalPressed(){

  }

  Widget getJournalVariantDetailsTile({required int nVariant, required DateTime uploadedOn, required String uploadedBy, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isDarkTheme ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
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

  Widget getJournalTile({required String subject, required int nVariants, required AppThemeType appThemeType}) {

    assert(nVariants <= 2);

    List<Widget> gridChildren = List.generate(nVariants, (index) => getJournalVariantDetailsTile(
      nVariant: index + 1,
      uploadedOn: DateTime.now(),
      uploadedBy: "John Doe",
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PDFViewerScreen<PDFScreenSimpleBottomSheet>(
            screenLabel: "Journal",
            parameter: PDFScreenSimpleBottomSheet(
                nVariant: index + 1,
                uploadedBy: "John Doe",
                title: subject
            ),
          ),
        ));
      }
    ));

    if (nVariants < 2) {
      gridChildren.add(getAddPostContainer(
        isDarkTheme: appThemeType.isDarkTheme(),
        onPressed: onAddJournalPressed,
        label: "Add Journal",
      ));
    }


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


  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final UserState userState = context.select((UserCubit cubit) => cubit.state);
    final JournalState journalState = context.select((JournalBloc bloc) => bloc.state);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),

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
                              dropDownValue: journalState.selectedSubject,
                              onDropDownChanged: (val) {
                                context.read<JournalBloc>().add(
                                    JournalFetch(
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
              getJournalTile(subject: "C++", nVariants: 1, appThemeType: appThemeType),
              SizedBox(height: 20,),
              getJournalTile(subject: "Java", nVariants: 2, appThemeType: appThemeType),
              SizedBox(height: 20,),
              getJournalTile(subject: "Java", nVariants: 0, appThemeType: appThemeType),
            ],
          ),
        ),
      ),
    );
  }
}
