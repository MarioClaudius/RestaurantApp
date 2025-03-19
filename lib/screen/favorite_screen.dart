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
                child: ListTile(
                  leading: Icon(
                    Icons.settings
                  ),
                  title: const Text(
                    "Settings"
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.settingRoute.name,
                    );
                  },
                ),
              ),
            ]
          ),
        ],
      ),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {
          final favoriteRestaurantList = value.favoriteRestaurantList;
          if (favoriteRestaurantList == null || favoriteRestaurantList.isEmpty) {
            return Center(
              child: Text(
                'No Favorite Restaurant Added',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: favoriteRestaurantList.length,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.read<LocalDatabaseProvider>().message)),
                  );
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