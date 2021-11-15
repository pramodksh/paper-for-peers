import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:papers_for_peers/config/app_theme.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeDark());

  void toggle() {
    if (state is AppThemeDark) {
      emit(AppThemeLight());
    } else {
      emit(AppThemeDark());
    }
  }

  void setAppTheme(AppThemeType appThemeType) {
    if (appThemeType.isDarkTheme()) {
      emit(AppThemeDark());
    } else {
      emit(AppThemeLight());
    }
  }
}
