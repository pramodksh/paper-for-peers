import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/journal_repository/journal_repository.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/notes_repository/notes_repository.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/question_paper_repository/question_paper_repository.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/syllabus_copy_repository/syllabus_copy_repository.dart';
import 'package:papers_for_peers/data/repositories/document_repositories/text_book_repository/text_book_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/image_picker/image_picker_repository.dart';
import 'package:papers_for_peers/logic/blocs/journal/journal_bloc.dart';
import 'package:papers_for_peers/logic/blocs/kud_notifications/kud_notifications_bloc.dart';
import 'package:papers_for_peers/logic/blocs/notes/notes_bloc.dart';
import 'package:papers_for_peers/logic/blocs/question_paper/question_paper_bloc.dart';
import 'package:papers_for_peers/logic/blocs/syllabus_copy/syllabus_copy_bloc.dart';
import 'package:papers_for_peers/logic/blocs/text_book/text_book_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/user/user_cubit.dart';
import 'package:papers_for_peers/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  print("RUN MAIN");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print("BUILD MAIN()");

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<FirestoreRepository>(
          create: (context) => FirestoreRepository(),
        ),
        RepositoryProvider<FirebaseStorageRepository>(
          create: (context) => FirebaseStorageRepository(),
        ),
        RepositoryProvider<ImagePickerRepository>(
          create: (context) => ImagePickerRepository(),
        ),
        RepositoryProvider<FilePickerRepository>(
          create: (context) => FilePickerRepository(),
        ),

        RepositoryProvider<QuestionPaperRepository>(
          create: (context) => QuestionPaperRepository(),
        ),
        RepositoryProvider<JournalRepository>(
          create: (context) => JournalRepository(),
        ),
        RepositoryProvider<NotesRepository>(
          create: (context) => NotesRepository(),
        ),
        RepositoryProvider<SyllabusCopyRepository>(
          create: (context) => SyllabusCopyRepository(),
        ),
        RepositoryProvider<TextBookRepository>(
          create: (context) => TextBookRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppThemeCubit>(
            create: (context) => AppThemeCubit(),
          ),
          BlocProvider<KudNotificationsBloc>(
            create: (context) => KudNotificationsBloc(),
          ),
          BlocProvider<QuestionPaperBloc>(
            create: (context) =>
                QuestionPaperBloc(
                  questionPaperRepository: context.read<QuestionPaperRepository>(),
                  filePickerRepository: context.read<FilePickerRepository>(),
                ),
          ),
          BlocProvider<JournalBloc>(
            create: (context) =>
                JournalBloc(
                  journalRepository: context.read<JournalRepository>(),
                  filePickerRepository: context.read<FilePickerRepository>(),
                ),
          ),
          BlocProvider<NotesBloc>(
            create: (context) =>
                  NotesBloc(
                  notesRepository: context.read<NotesRepository>(),
                  filePickerRepository: context.read<FilePickerRepository>(),
                ),
          ),
          BlocProvider<SyllabusCopyBloc>(
            create: (context) =>
                SyllabusCopyBloc(
                  syllabusCopyRepository: context.read<SyllabusCopyRepository>(),
                  filePickerRepository: context.read<FilePickerRepository>(),
                ),
          ),
          BlocProvider<TextBookBloc>(
            create: (context) =>
                TextBookBloc(
                  textBookRepository: context.read<TextBookRepository>(),
                  filePickerRepository: context.read<FilePickerRepository>(),
                ),
          ),

          BlocProvider<UserCubit>(
            create: (context) =>
                UserCubit(
                  firestoreRepository: context.read<FirestoreRepository>(),
                  firebaseStorageRepository: context.read<
                      FirebaseStorageRepository>(),
                  imagePickerRepository: context.read<ImagePickerRepository>(),
                  authRepository: context.read<AuthRepository>(),
                ),
          ),
        ],
        child: Builder(
          builder: (context) {
            AppThemeState appThemeState = context.watch<AppThemeCubit>().state;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(
                context: context,
                appThemeType: appThemeState is AppThemeLight ? AppThemeType.light : AppThemeType.dark,
              ),
              home: Wrapper(),
            );
          }
        ),
      ),
    );
  }
}
