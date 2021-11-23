import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/config/export_config.dart';
import 'package:papers_for_peers/data/models/document_models/question_paper_model.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/question_paper/question_paper_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/compare_question_paper/show_split_options.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/skeleton_loader.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/dialogs.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class QuestionPaper extends StatelessWidget {

  Widget _getQuestionVariantContainer({
    required int nVariant,
    required Function() onPressed,
    double containerRadius = 15,
    double containerHeight = 80,
    double containerWidth = 180,
    double containerMargin = 20,
    required AppThemeType appThemeType,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(right: containerMargin),
        height: containerHeight,
        width: containerWidth,
        child: Center(child: Text("Variant $nVariant", style: TextStyle(fontSize: 18, color: CustomColors.bottomNavBarUnselectedIconColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),)),
        decoration: BoxDecoration(
          color: appThemeType.isDarkTheme() ? CustomColors.bottomNavBarColor : CustomColors.lightModeBottomNavBarColor,
          borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
        ),
      ),
    );
  }

  Widget _getQuestionYearTile({required String year, required List<Widget> children}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(year, style: TextStyle(fontSize: 44, color: Colors.white38),),
          SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  bool _isDisplayAddQuestionPaperContainer({required int totalQuestionPapers}) => totalQuestionPapers < AppConstants.maxQuestionPapers;

  Widget _getQuestionPaperListWidget({
    required List<QuestionPaperYearModel> questionPaperYears,
    required bool isDarkTheme,
    required QuestionPaperState questionPaperState,
    required UserState userState,
    required BuildContext context,
    required AppThemeType appThemeType,
    bool isWidgetLoading = false,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          onPressed: () {
            // todo implement compare question paper
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowSplitOptions(questionPaperYears: questionPaperYears,),
            ));
          },
          child: Text("Compare Question Papers", style: TextStyle(fontSize: 18),),
        ),
        SizedBox(height: 20,),
        ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 15),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 20,),
          itemCount: questionPaperYears.length,
          itemBuilder: (context, questionPaperYearIndex) {

            List<Widget> variants = List.generate(questionPaperYears[questionPaperYearIndex].questionPaperModels.length, (questionPaperIndex) {
              return _getQuestionVariantContainer(
                appThemeType: appThemeType,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PDFViewerScreen<PDFScreenSimpleBottomSheet>(
                      documentUrl: questionPaperYears[questionPaperIndex].questionPaperModels[questionPaperIndex].documentUrl,
                      screenLabel: "Question Paper",
                      parameter: PDFScreenSimpleBottomSheet(
                        title: questionPaperYears[questionPaperYearIndex].year.toString(),
                        nVariant: questionPaperYears[questionPaperYearIndex].questionPaperModels[questionPaperIndex].version,
                        uploadedBy: questionPaperYears[questionPaperYearIndex].questionPaperModels[questionPaperIndex].uploadedBy,
                      ),
                    ),
                  ));
                },
                nVariant: questionPaperYears[questionPaperYearIndex].questionPaperModels[questionPaperIndex].version,
              );
            });

            if (_isDisplayAddQuestionPaperContainer(totalQuestionPapers: questionPaperYears[questionPaperYearIndex].questionPaperModels.length)) {
              variants.add(SizedBox(
                width: 180,
                height: 80,
                child: getAddPostContainer(
                  isDarkTheme: isDarkTheme,
                  label: questionPaperState is QuestionPaperAddLoading ? "Loading" : "Add Question Paper",
                  onPressed: questionPaperState is QuestionPaperAddLoading || isWidgetLoading ? () {} : () {
                    if (userState is UserLoaded) {
                      context.read<QuestionPaperBloc>().add(QuestionPaperAdd(
                        questionPaperYears: questionPaperYears,
                        year: questionPaperYears[questionPaperYearIndex].year,
                        uploadedBy: userState.userModel.displayName!,
                        course: userState.userModel.course!.courseName!,
                        semester: userState.userModel.semester!.nSemester!,
                        subject: questionPaperState.selectedSubject!,
                        nVersion: questionPaperYears[questionPaperYearIndex].questionPaperModels.length + 1,
                        user: userState.userModel,
                      ));
                    }
                  },
                ),
              ));
            }

            return _getQuestionYearTile(
              year: questionPaperYears[questionPaperYearIndex].year.toString(),
              children: variants,
            );

          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final AppThemeType appThemeType = context.select((AppThemeCubit cubit) => cubit.state.appThemeType);
    final UserState userState = context.select((UserCubit cubit) => cubit.state);
    final QuestionPaperState questionPaperState = context.watch<QuestionPaperBloc>().state;

    return BlocListener<QuestionPaperBloc, QuestionPaperState>(
      listener: (context, state) {
        if (state is QuestionPaperFetchError) {
          showAlertDialog(context: context, text: state.errorMessage);
        }
        if (state is QuestionPaperAddError) {
          showAlertDialog(context: context, text: state.errorMessage);
        }
        if (state is QuestionPaperAddSuccess) {
          showAlertDialog(context: context, text: "Question Paper Added Successfully").then((value) {
            if (userState is UserLoaded) {
              context.read<QuestionPaperBloc>().add(QuestionPaperFetch(
                  course: userState.userModel.course!.courseName!,
                  semester: userState.userModel.semester!.nSemester!,
                  subject: questionPaperState.selectedSubject!
              ));
            }
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
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
                                    dropDownValue: questionPaperState.selectedSubject,
                                    onDropDownChanged: (val) {
                                      context.read<QuestionPaperBloc>().add(
                                          QuestionPaperFetch(
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
                    SizedBox(height: 30,),

                    Builder(
                      builder: (context) {

                        if (userState is UserLoaded && questionPaperState.selectedSubject == null) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(child: Text("Select Subject to Continue", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,)),
                          );
                        } else if (questionPaperState is QuestionPaperFetchLoading) {
                          return SkeletonLoader(
                            appThemeType: appThemeType,
                            child: _getQuestionPaperListWidget(
                              isWidgetLoading: true,
                              questionPaperYears: List.generate(3, (index) => QuestionPaperYearModel(
                                  year: DateTime.now().year - index,
                                  questionPaperModels: List.generate(2, (index) => QuestionPaperModel(
                                      documentUrl: "",
                                      uploadedOn: DateTime.now(),
                                      userEmail: "",
                                      userProfilePhotoUrl: "",
                                      userUid: "",
                                      version: 0,
                                      uploadedBy: ""
                                  ))
                              )),
                              isDarkTheme: appThemeType.isDarkTheme(),
                              questionPaperState: questionPaperState,
                              userState: userState,
                              context: context,
                              appThemeType: appThemeType,
                            ),
                          );
                        } else if (questionPaperState is QuestionPaperFetchSuccess) {
                          return _getQuestionPaperListWidget(
                            questionPaperYears: questionPaperState.questionPaperYears,
                            isDarkTheme: appThemeType.isDarkTheme(),
                            questionPaperState: questionPaperState,
                            userState: userState,
                            context: context,
                            appThemeType: appThemeType,
                          );
                        } else if (questionPaperState is QuestionPaperAddLoading) {
                          return _getQuestionPaperListWidget(
                            appThemeType: appThemeType,
                            questionPaperYears:  questionPaperState.questionPaperYears,
                            isDarkTheme: appThemeType.isDarkTheme(),
                            questionPaperState: questionPaperState,
                            userState: userState,
                            context: context,
                          );
                        } else if (questionPaperState is QuestionPaperAddError) {
                          return _getQuestionPaperListWidget(
                            appThemeType: appThemeType,
                            questionPaperYears:  questionPaperState.questionPaperYears,
                            isDarkTheme: appThemeType.isDarkTheme(),
                            questionPaperState: questionPaperState,
                            userState: userState,
                            context: context,
                          );
                        } else if (questionPaperState is QuestionPaperAddSuccess) {
                          return _getQuestionPaperListWidget(
                            appThemeType: appThemeType,
                            questionPaperYears:  questionPaperState.questionPaperYears,
                            isDarkTheme: appThemeType.isDarkTheme(),
                            questionPaperState: questionPaperState,
                            userState: userState,
                            context: context,
                          );
                        } else {
                          return Center(child: CircularProgressIndicator.adaptive(),);
                        }
                      },
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
