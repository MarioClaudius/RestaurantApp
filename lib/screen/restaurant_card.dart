import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final Function() onTap;

  RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 80,
                minHeight: 80,
                maxWidth: 120,
                minWidth: 120,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox.square(dimension: 8),
            Expanded(
              child: Column(
                children: [
                  Text(
                    restaurant.name
                  ),
                  const SizedBox.square(dimension: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.place_rounded
                      ),
                      const SizedBox.square(dimension: 4),
                      Text(restaurant.city),
                    ],
                  ),
                  const SizedBox.square(dimension: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                      ),
                      const SizedBox.square(dimension: 4),
                      Text(restaurant.rating.toString())
                    ],
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}