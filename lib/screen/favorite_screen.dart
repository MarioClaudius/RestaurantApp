import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/local_notification_provider.dart';
import 'package:restaurant_app/provider/shared_preferences_provider.dart';
import 'package:restaurant_app/screen/restaurant_card.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadAllFavoriteRestaurants();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadAllFavoriteRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurant List"),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Consumer<SharedPreferencesProvider>(
                      builder: (context, sharedPreferencesProvider, child) {
                        final bool isDarkMode = sharedPreferencesProvider.isDarkMode!;
                        return ListTile(
                          leading: Icon(
                              isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode
                          ),
                          title: Text(
                              isDarkMode
                                  ? "Dark Mode"
                                  : "Light Mode"
                          ),
                          onTap: () async {
                            await sharedPreferencesProvider.changeThemeMode();
                            sharedPreferencesProvider.getIsDarkModeValue();
                            MainApp.of(context).changeTheme(!sharedPreferencesProvider.isDarkMode!);
                            Navigator.pop(context);
                          },
                        );
                      }
                  ),
                ),
                PopupMenuItem(
                  child: Consumer<SharedPreferencesProvider>(
                      builder: (context, sharedPreferencesProvider, child) {
                        final bool isScheduleActive = sharedPreferencesProvider.isScheduleActive!;
                        return ListTile(
                          leading: Icon(
                              isScheduleActive
                                  ? Icons.cancel
                                  : Icons.schedule
                          ),
                          title: Text(
                              isScheduleActive
                                  ? "Cancel Daily Lunch Reminder"
                                  : "Set Daily Lunch Reminder"
                          ),
                          onTap: () async {
                            LocalNotificationProvider localNotificationProvider = context.read<LocalNotificationProvider>();
                            await sharedPreferencesProvider.toggleSchedule();
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
                            Navigator.pop(context);
                          },
                        );
                      }
                  ),
                ),
              ]
          ),
        ],
      ),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {
          if (value.favoriteRestaurantList == null) {
            return const SizedBox();
          }
          final favoriteRestaurantList = value.favoriteRestaurantList;
          return ListView.builder(
            itemCount: favoriteRestaurantList!.length,
            itemBuilder: (context, index) {
              final favoriteRestaurant = favoriteRestaurantList[index];
              return RestaurantCard(
                restaurant: favoriteRestaurant,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NavigationRoute.detailRoute.name,
                    arguments: favoriteRestaurant.id,
                  );
                },
                isFavoriteCard: true,
                onTapIcon: () async {
                  final localDatabaseProvider = context.read<LocalDatabaseProvider>();
                  await localDatabaseProvider.removeFavoriteRestaurant(favoriteRestaurant.id);
                  await localDatabaseProvider.loadAllFavoriteRestaurants();
                },
              );
            }
          );
        }
      ),
    );
  }
}