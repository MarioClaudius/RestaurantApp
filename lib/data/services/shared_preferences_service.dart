import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String keyDarkMode = "DARKMODE";
  static const String keyScheduleIsActive = "SCHEDULEACTIVE";

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

  Future<void> toggleSchedule() async {
    final bool? scheduleIsActive = _preferences.getBool(keyScheduleIsActive);
    try {
      if (scheduleIsActive == null) {
        await _preferences.setBool(keyScheduleIsActive, true);
      } else {
        await _preferences.setBool(keyScheduleIsActive, !scheduleIsActive);
      }
    } catch (e) {
      throw Exception("Shared preferences cannot toggle schedule");
    }
  }

  bool isScheduleActive() {
    final bool? scheduleIsActive = _preferences.getBool(keyScheduleIsActive);
    return scheduleIsActive ?? false;
  }
}