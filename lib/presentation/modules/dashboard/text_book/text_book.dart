import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/document_models/text_book.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/text_book/text_book_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/skeleton_loader.dart';
import 'package:papers_for_peers/presentation/modules/utils/utils.dart';
import 'package:provider/provider.dart';


class TextBook extends StatelessWidget {

  final DateFormat dateFormat = DateFormat("dd MMMM yyyy");

  Widget _getTextBookVariantDetailsTile({
    required int nVariant, required DateTime uploadedOn, required String uploadedBy,
    required Function() onTap, required AppThemeType appThemeType, required String? profilePhotoUrl,
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
                Utils.getProfilePhotoWidget(url: profilePhotoUrl, username: uploadedBy, radius: 15, fontSize: 16),
                SizedBox(width: 10,),
                Text(uploadedBy, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTextBookTile({
    required String subject, required List<TextBookModel> textBooks,
    required List<TextBookSubjectModel> textBookSubjects,
    required AppThemeType appThemeType, required UserState userState,
    required bool isAddTextBookLoading, required bool isWidgetLoading,
    required BuildContext context
  }) {

    List<Widget> gridChildren = List.generate(AppConstants.maxTextBooks, (index) {
      int currentVersion = index + 1;
      bool isShow = textBooks.any((element) => element.version == currentVersion);

      if (isShow) {
        TextBookModel currentTextBookModel = textBooks.firstWhere((element) => element.version == currentVersion);
        return _getTextBookVariantDetailsTile(
            appThemeType: appThemeType,
            nVariant: currentVersion,
            profilePhotoUrl: currentTextBookModel.userProfilePhotoUrl,
            uploadedOn: currentTextBookModel.uploadedOn,
            uploadedBy: currentTextBookModel.uploadedBy,
            onTap: isWidgetLoading ? () {} : () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PDFViewerScreen<PDFScreenSimpleBottomSheet>(
                  onReportPressed: (values) {
                    if (userState is UserLoaded) {
                      context.read<TextBookBloc>().add(TextBookReportAdd(
                        reportValues: values,
                        textBookSubjects: textBookSubjects,
                        uploadedBy: userState.userModel.displayName!,
                        course: userState.userModel.course!.courseName!,
                        semester: userState.userModel.semester!.nSemester!,
                        subject: subject,
                        nVersion: currentVersion,
                        user: userState.userModel,
                      ));
                    }
                  },
                  documentUrl: currentTextBookModel.documentUrl,
                  screenLabel: "Text Book",
                  parameter: PDFScreenSimpleBottomSheet(
                      profilePhotoUrl: currentTextBookModel.userProfilePhotoUrl,
                      nVariant: currentTextBookModel.version,
                      uploadedBy: currentTextBookModel.uploadedBy,
                      title: subject
                  ),
                ),
              ));
            }
        );
      } else {
        return Utils.getAddPostContainer(
          isDarkTheme: appThemeType.isDarkTheme(),
          onPressed: isAddTextBookLoading || isWidgetLoading ? () {} : () {
            if (userState is UserLoaded) {
              context.read<TextBookBloc>().add(TextBookAdd(
                textBookSubjects: textBookSubjects,
                uploadedBy: userState.userModel.displayName!,
                course: userState.userModel.course!.courseName!,
                semester: userState.userModel.semester!.nSemester!,
                subject: subject,
                nVersion: currentVersion,
                user: userState.userModel,
              ));
            }
          },
          label: isAddTextBookLoading ? "Loading" : "Add Text Book",
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

  Widget _getTextBookListWidget({
    required UserState userState,
    required List<TextBookSubjectModel> textBookSubjects,
    required AppThemeType appThemeType,
    required bool isAddTextBookLoading,
    bool isWidgetLoading = false,
  }) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 20,),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: textBookSubjects.length,
      itemBuilder: (context, textbookSubjectIndex) {
        return _getTextBookTile(
            textBookSubjects: textBookSubjects,
            context: context,
            isWidgetLoading: isWidgetLoading,
            isAddTextBookLoading: isAddTextBookLoading,
            textBooks: textBookSubjects[textbookSubjectIndex].textBookModels,
            subject: textBookSubjects[textbookSubjectIndex].subject,
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
    final TextBookState textBookState = context.watch<TextBookBloc>().state;

    if (textBookState is TextBookInitial) {
      if (userState is UserLoaded)
        context.read<TextBookBloc>().add(
            TextBookFetch(
              course: userState.userModel.course!.courseName!,
              semester: userState.userModel.semester!.nSemester!,
            )
        );
    }

    return BlocListener<TextBookBloc, TextBookState>(
      listener: (context, state) {
        if (state is TextBookFetchError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        } else if (state is TextBookAddError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        } else if (state is TextBookAddSuccess) {
          Utils.showAlertDialog(context: context, text: "Text Book Added Successfully");
        } else if (state is TextBookReportSuccess) {
          Utils.showAlertDialog(context: context, text: "Text Book Reported Successfully");
        } else if (state is TextBookReportError) {
          Utils.showAlertDialog(context: context, text: state.errorMessage);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: RefreshIndicator(
          onRefresh: () async {
            if (userState is UserLoaded) {
              context.read<TextBookBloc>().add(
                  TextBookFetch(
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
                    if (textBookState is TextBookFetchLoading) {
                      return SkeletonLoader(
                        appThemeType: appThemeType,
                        child: _getTextBookListWidget(
                          isWidgetLoading: true,
                          userState: userState,
                          textBookSubjects: List.generate(2, (index) => TextBookSubjectModel(
                            subject: "",
                            textBookModels: List.generate(2, (index) => TextBookModel(
                              uploadedOn: DateTime.now(),
                              userEmail: "",
                              userProfilePhotoUrl: "",
                              userUid: "",
                              uploadedBy: "",
                              version: index,
                              documentUrl: "",
                            ))
                          )),
                          appThemeType: appThemeType,
                          isAddTextBookLoading: false,
                        ),
                      );
                    } else if (textBookState is TextBookFetchSuccess) {
                      return _getTextBookListWidget(
                        userState: userState,
                        textBookSubjects: textBookState.textBookSubjects,
                        appThemeType: appThemeType,
                        isAddTextBookLoading: false,
                      );
                    } else if (textBookState is TextBookAddError) {
                      return _getTextBookListWidget(
                        userState: userState,
                        textBookSubjects: textBookState.textBookSubjects,
                        appThemeType: appThemeType,
                        isAddTextBookLoading: false,
                      );
                    } else if (textBookState is TextBookAddSuccess) {
                      return _getTextBookListWidget(
                        userState: userState,
                        textBookSubjects: textBookState.textBookSubjects,
                        appThemeType: appThemeType,
                        isAddTextBookLoading: false,
                      );
                    } else if (textBookState is TextBookAddLoading) {
                      return _getTextBookListWidget(
                        userState: userState,
                        textBookSubjects: textBookState.textBookSubjects,
                        appThemeType: appThemeType,
                        isAddTextBookLoading: true,
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
