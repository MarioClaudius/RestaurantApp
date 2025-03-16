import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/local_notification_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/shared_preferences_provider.dart';
import 'package:restaurant_app/screen/restaurant_card.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
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
                        MainApp.of(context).changeTheme(sharedPreferencesProvider.isDarkMode!);
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
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch(value.resultState) {
            RestaurantListLoadingState() => Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantListLoadedState(data: var restaurantList) => ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                final restaurant = restaurantList[index];
                return Consumer<LocalDatabaseProvider>(
                  builder: (context, dbProvider, child) {
                    return RestaurantCard(
                      restaurant: restaurant,
                      isFavoriteCard: false,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          NavigationRoute.detailRoute.name,
                          arguments: restaurant.id,
                        );
                      },
                      onTapIcon: () async {
                        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
                        await localDatabaseProvider.checkRestaurantIsFavorite(restaurant.id);
                        if (localDatabaseProvider.isFavoriteRestaurant != null && localDatabaseProvider.isFavoriteRestaurant!) {
                          await localDatabaseProvider.removeFavoriteRestaurant(restaurant.id);
                        } else {
                          final restaurantDetailProvider = context.read<RestaurantDetailProvider>();
                          await restaurantDetailProvider.fetchRestaurantDetail(restaurant.id);
                          switch(restaurantDetailProvider.resultState) {
                            case RestaurantDetailLoadedState(data: var restaurantData):
                              await localDatabaseProvider.saveFavoriteRestaurant(restaurantData);
                            case _ :
                              // do nothing
                          }
                        }
                      },
                    );
                  }
                );
              }
            ),
            RestaurantListErrorState(error: var message) => Center(
              child: Text(
                message,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            _ => const SizedBox(),
          };
        }
      ),
    );
  }

  Future<void> _scheduleDailyLunchNotification() async {

  }
}