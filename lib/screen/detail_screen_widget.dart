import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class DetailScreenWidget extends StatelessWidget {
  final Restaurant restaurant;

  const DetailScreenWidget({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
              fit: BoxFit.cover,
            ),
            const SizedBox.square(dimension: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        restaurant.city,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox.square(dimension: 4),
                    Text(
                      restaurant.rating.toString(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox.square(dimension: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    "Food",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox.square(dimension: 10),
                  Column(
                    children: restaurant.menus!.foods.map((food) => Text(
                      food.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )).toList()
                  ),
                  const SizedBox.square(dimension: 16),
                  Text(
                    "Drink",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox.square(dimension: 10),
                  Column(
                    children: restaurant.menus!.drinks.map((drink) => Text(
                      drink.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )).toList()
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}