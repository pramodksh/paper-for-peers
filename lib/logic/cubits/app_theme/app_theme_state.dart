part of 'app_theme_cubit.dart';

@immutable
abstract class AppThemeState {
  AppThemeType get appThemeType;
}

class AppThemeLight extends AppThemeState {

  @override
  AppThemeType get appThemeType => AppThemeType.light;

}

class AppThemeDark extends AppThemeState {

  @override
  AppThemeType get appThemeType => AppThemeType.dark;
}
