import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papers_for_peers/config/app_theme.dart';
import 'package:papers_for_peers/logic/cubits/app_theme/app_theme_cubit.dart';
import 'package:papers_for_peers/services/theme_provider/theme_provider.dart';
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

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.isDarkTheme =
    await themeChangeProvider.darkThemePreference.getAppTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppThemeCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {

          final AppThemeState appThemeState = context.watch<AppThemeCubit>().state;

          // todo add this
          // return MaterialApp(
          //   debugShowCheckedModeBanner: false,
          //   theme: Styles.themeData(
          //     context: context,
          //     appThemeType: appThemeState is AppThemeLight ? AppThemeType.light : AppThemeType.dark,
          //   ),
          //   home: Wrapper(),
          // );

          // todo remove change notifier
          return ChangeNotifierProvider(
            create: (_) {
              return themeChangeProvider;
            },
            child: Consumer<DarkThemeProvider>(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: Styles.themeData(
                  context: context,
                  appThemeType: appThemeState is AppThemeLight ? AppThemeType.light : AppThemeType.dark,
                ),
                home: Wrapper(),
              ),
              builder: (context, value, child) => child,
            ),
          );
        }
      ),
    );

    // return ChangeNotifierProvider(
    //   create: (_) {
    //     return themeChangeProvider;
    //   },
    //   child: Consumer<DarkThemeProvider>(
    //     builder: (context, value, child) {
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: Styles.themeData(themeChangeProvider.isDarkTheme, context),
    //         home: Wrapper(),
    //       );
    //     },
    //   ),
    // );
  }
}
