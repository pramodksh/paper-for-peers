import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/data/repositories/file_picker/file_picker_repository.dart';
import 'package:papers_for_peers/data/repositories/firebase_storage/firebase_storage_repository.dart';
import 'package:papers_for_peers/data/repositories/firestore/firestore_repository.dart';
import 'package:papers_for_peers/data/repositories/image_picker/image_picker_repository.dart';
import 'package:papers_for_peers/logic/blocs/kud_notifications/kud_notifications_bloc.dart';
import 'package:papers_for_peers/logic/blocs/question_paper/question_paper_bloc.dart';
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
                  firestoreRepository: context.read<FirestoreRepository>(),
                  filePickerRepository: context.read<FilePickerRepository>(),
                  firebaseStorageRepository: context.read<FirebaseStorageRepository>()
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(
            context: context,
            // appThemeType: appThemeState is AppThemeLight ? AppThemeType.light : AppThemeType.dark,
            appThemeType: AppThemeType.dark,
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}
