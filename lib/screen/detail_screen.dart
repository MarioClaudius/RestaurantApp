import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/local_notification_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/shared_preferences_provider.dart';
import 'package:restaurant_app/screen/detail_screen_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<StatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, result) {
        Navigator.pushNamed(
          context,
          NavigationRoute.mainRoute.name,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Restaurant Detail"),
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamed(
                context,
                NavigationRoute.mainRoute.name,
              );
            },
            icon: Icon(Icons.arrow_back)
          ),
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
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, value, child) {
            return switch(value.resultState) {
              RestaurantDetailLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
              RestaurantDetailLoadedState(data: var restaurant) => DetailScreenWidget(
                  restaurant: restaurant
              ),
              RestaurantDetailErrorState(error: var message) => Center(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              _ => const SizedBox()
            };
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final localDatabaseProvider = context.read<LocalDatabaseProvider>();
            await localDatabaseProvider.checkRestaurantIsFavorite(widget.restaurantId);
            if (localDatabaseProvider.isFavoriteRestaurant != null && localDatabaseProvider.isFavoriteRestaurant!) {
              await localDatabaseProvider.removeFavoriteRestaurant(widget.restaurantId);
            } else {
              final restaurantDetailProvider = context.read<
                  RestaurantDetailProvider>();
              await restaurantDetailProvider.fetchRestaurantDetail(
                  widget.restaurantId);
              switch (restaurantDetailProvider.resultState) {
                case RestaurantDetailLoadedState(data: var restaurantData):
                  await localDatabaseProvider.saveFavoriteRestaurant(
                      restaurantData);
                case _ :
                // do nothing
              }
            }
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.favorite),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}