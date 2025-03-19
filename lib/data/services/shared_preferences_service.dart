import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String keyDarkMode = "DARKMODE";
  static const String keyScheduleIsActive = "SCHEDULEACTIVE";

  Future<void> changeThemeMode(bool value) async {
    try {
      await _preferences.setBool(keyDarkMode, value);
    } catch (e) {
      throw Exception("Shared preferences cannot change mode.");
    }
  }

  bool isDarkMode() {
    final bool? isDarkMode = _preferences.getBool(keyDarkMode);
    return isDarkMode ?? false;
  }

  Future<void> setDailyLunchNotificationSchedule(bool value) async {
    try {
      await _preferences.setBool(keyScheduleIsActive, value);
    } catch (e) {
      throw Exception("Shared preferences cannot set daily lunch notification schedule");
    }
  }

  bool isScheduleActive() {
    final bool? scheduleIsActive = _preferences.getBool(keyScheduleIsActive);
    return scheduleIsActive ?? false;
  }
}