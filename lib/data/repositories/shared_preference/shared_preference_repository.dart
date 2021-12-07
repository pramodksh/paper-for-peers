import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceRepository {
  static String isShowIntroScreenKey = "isShowIntroScreen";

  Future<void> setIsShowIntroScreen(bool isShowIntroScreen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isShowIntroScreenKey, isShowIntroScreen);
  }

  Future<bool> getIsShowIntroScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isShowIntroScreenKey) ?? false;
  }


}