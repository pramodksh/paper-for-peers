import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/data/repositories/auth/auth_repository.dart';
import 'package:papers_for_peers/logic/blocs/auth/auth_bloc.dart';
import 'package:papers_for_peers/logic/blocs/kud_notifications/kud_notifications_bloc.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/logic/cubits/course_and_semester/course_and_semester_cubit.dart';
import 'package:papers_for_peers/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<AppThemeCubit>(
            create: (context) => AppThemeCubit(),
          ),
          BlocProvider<KudNotificationsBloc>(
            create: (context) => KudNotificationsBloc(),
          ),
          BlocProvider<CourseAndSemesterCubit>(
            create: (context) => CourseAndSemesterCubit(),
          ),
        ],
        child: Builder(
            builder: (context) {
              final AppThemeState appThemeState = context.watch<AppThemeCubit>().state;

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
