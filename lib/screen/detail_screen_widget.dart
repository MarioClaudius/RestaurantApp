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
                      Text(restaurant.name),
                      Text(restaurant.city),
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
                      restaurant.rating.toString()
                    ),
                  ],
                )
              ],
            ),
            const SizedBox.square(dimension: 16),
          ],
        ),
      ),
    );
  }
}