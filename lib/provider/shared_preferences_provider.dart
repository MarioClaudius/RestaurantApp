import 'package:flutter/material.dart';
import 'package:restaurant_app/data/services/shared_preferences_service.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPreferencesProvider(this._service);

  String _message = "";
  String get message => _message;

  bool? _isDarkMode;
  bool? get isDarkMode => _isDarkMode;

  bool? _isScheduleActive;
  bool? get isScheduleActive => _isScheduleActive;

  Future<void> changeThemeMode(bool value) async {
    try {
      await _service.changeThemeMode(value);
      _message = "Theme mode changed successfully";
    } catch (e) {
      _message = "Change theme mode failed";
    }
    notifyListeners();
  }

  void getIsDarkModeValue() async {
    try {
      _isDarkMode = _service.isDarkMode();
      _message = "Theme mode value fetched successfully";
    } catch (e) {
      _message = "Theme mode value failed to be fetched";
    }
    notifyListeners();
  }

  Future<void> setDailyLunchNotificationSchedule(bool value) async {
    try {
      await _service.setDailyLunchNotificationSchedule(value);
      if(value) {
        _message = "Daily lunch notification schedule turned on successfully";
      } else {
        _message = "Daily lunch notification schedule turned off successfully";
      }
    } catch (e) {
      _message = "Set daily lunch notification schedule failed";
    }
    notifyListeners();
  }

  void getIsScheduleActive() async {
    try {
      _isScheduleActive = _service.isScheduleActive();
      _message = "Schedule status value fetched successfully";
    } catch (e) {
      _message = "Schedule status value failed to be fetched";
    }
    notifyListeners();
  }
}