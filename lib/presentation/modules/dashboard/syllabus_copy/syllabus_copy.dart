import 'package:flutter/material.dart';
import 'package:papers_for_peers/data/models/pdf_screen_parameters.dart';
import 'package:papers_for_peers/logic/blocs/syllabus_copy/syllabus_copy_bloc.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/presentation/modules/dashboard/shared/PDF_viewer_screen.dart';
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

    print("STATE: ${syllabusCopyState}");

    if (syllabusCopyState is SyllabusCopyInitial) {
      if (userState is UserLoaded)
      context.read<SyllabusCopyBloc>().add(SyllabusCopyFetch(
        course: userState.userModel.course!.courseName!,
        semester: userState.userModel.semester!.nSemester!,
      ));
    }

    return Scaffold(
      body: PDFViewerScreen<PDFScreenSyllabusCopy>(
        screenLabel: "Syllabus Copy",
        isShowBottomSheet: false,
        parameter: PDFScreenSyllabusCopy(
          uploadedBy: "John Doe",
          nVariant: 1,
          totalVariants: 1,
        ),
      ),
    );
  }
}
