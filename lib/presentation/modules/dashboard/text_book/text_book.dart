import 'package:auto_size_text/auto_size_text.dart';
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

  Widget _getTextBookTile({
    required String subject, required List<TextBookModel> textBooks,
    required List<TextBookSubjectModel> textBookSubjects,
    required AppThemeType appThemeType, required UserState userState,
    required bool isAddTextBookLoading, required bool isWidgetLoading,
    required BuildContext context, required int maxTextBooks
  }) {

    List<Widget> children = List.generate(textBooks.length, (index) {
      TextBookModel currentTextBookModel = textBooks[index];
      return _getTextBookVariantDetailsTile(
          appThemeType: appThemeType,
          nVariant: index+1,
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
                      textBookId: currentTextBookModel.id,
                      user: userState.userModel,
                    ));
                  }
                },
                documentUrl: currentTextBookModel.documentUrl,
                screenLabel: "Text Book",
                parameter: PDFScreenSimpleBottomSheet(
                    profilePhotoUrl: currentTextBookModel.userProfilePhotoUrl,
                    nVariant: index+1,
                    uploadedBy: currentTextBookModel.uploadedBy,
                    title: subject
                ),
              ),
            ));
          }
      );
    });

    if (textBooks.length < maxTextBooks) {
      children.add(Utils.getAddPostContainer(
        isDarkTheme: appThemeType.isDarkTheme(),
        onPressed: isAddTextBookLoading || isWidgetLoading ? () {} : () {
          if (userState is UserLoaded) {
            context.read<TextBookBloc>().add(TextBookAdd(
              textBookSubjects: textBookSubjects,
              uploadedBy: userState.userModel.displayName!,
              course: userState.userModel.course!.courseName!,
              semester: userState.userModel.semester!.nSemester!,
              subject: subject,
              user: userState.userModel,
            ));
          }
        },
        label: isAddTextBookLoading ? "Loading" : "Add Text Book",
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

  Widget _getTextBookListWidget({
    required UserState userState,
    required List<TextBookSubjectModel> textBookSubjects,
    required AppThemeType appThemeType,
    required bool isAddTextBookLoading,
    required int maxTextBooks,
    bool isWidgetLoading = false,
  }) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 20,),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: textBookSubjects.length,
      itemBuilder: (context, textbookSubjectIndex) {
        return _getTextBookTile(
          maxTextBooks: maxTextBooks,
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
          Utils.showAlertDialog(context: context, text: "Text Book Successfully Submitted");
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
                          maxTextBooks: textBookState.maxTextBooks,
                          isWidgetLoading: true,
                          userState: userState,
                          textBookSubjects: List.generate(2, (index) => TextBookSubjectModel(
                            subject: "",
                            textBookModels: List.generate(2, (index) => TextBookModel(
                              id: "",
                              uploadedOn: DateTime.now(),
                              userEmail: "",
                              userProfilePhotoUrl: "",
                              userUid: "",
                              uploadedBy: "",
                              documentUrl: "",
                            ))
                          )),
                          appThemeType: appThemeType,
                          isAddTextBookLoading: false,
                        ),
                      );
                    } else if (textBookState is TextBookFetchSuccess) {
                      return _getTextBookListWidget(
                        maxTextBooks: textBookState.maxTextBooks,
                        userState: userState,
                        textBookSubjects: textBookState.textBookSubjects,
                        appThemeType: appThemeType,
                        isAddTextBookLoading: false,
                      );
                    } else if (textBookState is TextBookAddError) {
                      return _getTextBookListWidget(
                        maxTextBooks: textBookState.maxTextBooks,
                        userState: userState,
                        textBookSubjects: textBookState.textBookSubjects,
                        appThemeType: appThemeType,
                        isAddTextBookLoading: false,
                      );
                    } else if (textBookState is TextBookAddSuccess) {
                      return _getTextBookListWidget(
                        maxTextBooks: textBookState.maxTextBooks,
                        userState: userState,
                        textBookSubjects: textBookState.textBookSubjects,
                        appThemeType: appThemeType,
                        isAddTextBookLoading: false,
                      );
                    } else if (textBookState is TextBookAddLoading) {
                      return _getTextBookListWidget(
                        maxTextBooks: textBookState.maxTextBooks,
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
