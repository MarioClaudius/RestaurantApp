import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String keyDarkMode = "DARKMODE";

  Future<void> changeThemeMode() async {
    final bool? isDarkMode = _preferences.getBool(keyDarkMode);
    try {
      if (isDarkMode == null) {
        await _preferences.setBool(keyDarkMode, true);
      } else {
        await _preferences.setBool(keyDarkMode, !isDarkMode);
      }
    } catch (e) {
      throw Exception("Shared preferences cannot change mode.");
    }
  }

  bool isDarkMode() {
    final bool? isDarkMode = _preferences.getBool(keyDarkMode);
    return isDarkMode ?? false;
  }
}