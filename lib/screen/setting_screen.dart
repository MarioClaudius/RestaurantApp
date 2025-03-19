import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/provider/local_notification_provider.dart';
import 'package:restaurant_app/provider/shared_preferences_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Theme Mode',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Change to light/dark mode'),
                    ],
                  )
                ),
                Consumer<SharedPreferencesProvider>(
                  builder: (context, sharedPreferencesProvider, child) {
                    final bool isDarkMode = sharedPreferencesProvider.isDarkMode!;
                    return Switch(
                      value: isDarkMode,
                      thumbIcon: WidgetStateProperty.resolveWith<Icon>(
                        (Set<WidgetState> states) {
                          return Icon(states.contains(WidgetState.selected)
                              ? Icons.dark_mode
                              : Icons.light_mode
                          );
                        },
                      ),
                      onChanged: (value) async {
                        await sharedPreferencesProvider.changeThemeMode(value);
                        sharedPreferencesProvider.getIsDarkModeValue();
                      }
                    );
                  }
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Daily Lunch Notification',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Schedule daily lunch notification'),
                    ],
                  )
                ),
                Consumer<SharedPreferencesProvider>(
                  builder: (context, sharedPreferencesProvider, child) {
                    final bool isScheduleActive = sharedPreferencesProvider.isScheduleActive!;
                    return Switch(
                      value: isScheduleActive,
                      thumbIcon: WidgetStateProperty.resolveWith<Icon>(
                        (Set<WidgetState> states) {
                          return Icon(states.contains(WidgetState.selected)
                              ? Icons.schedule
                              : Icons.cancel
                          );
                        },
                      ),
                      onChanged: (value) async {
                        LocalNotificationProvider localNotificationProvider = context.read<LocalNotificationProvider>();
                        await sharedPreferencesProvider.setDailyLunchNotificationSchedule(value);
                        sharedPreferencesProvider.getIsScheduleActive();
                        if (sharedPreferencesProvider.isScheduleActive!) {
                          await localNotificationProvider.scheduleDailyLunchNotification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Notification Scheduled!")),
                          );
                        } else {
                          await localNotificationProvider.cancelNotification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Notification Canceled!")),
                          );
                        }
                      }
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}