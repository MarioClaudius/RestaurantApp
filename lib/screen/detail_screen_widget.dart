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
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
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
                          if (restaurant.address != null)
                            Text(
                              restaurant.address!,
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
                    ),
                  ],
                ),
                const SizedBox.square(dimension: 16),
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox.square(dimension: 5),
                Text(
                  restaurant.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
                const SizedBox.square(dimension: 16),
                Text(
                  "Foods",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (_, index) => Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      restaurant.menus!.foods[index].name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              childCount: restaurant.menus!.foods.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Drinks",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 16.0
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (_, index) => Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      restaurant.menus!.drinks[index].name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              childCount: restaurant.menus!.drinks.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
          ),
        ),
      ],
    );
  }
}