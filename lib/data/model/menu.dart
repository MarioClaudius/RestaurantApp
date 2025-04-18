import 'package:restaurant_app/data/model/drink.dart';
import 'package:restaurant_app/data/model/food.dart';

class Menu {
  final List<Food> foods;
  final List<Drink> drinks;

  Menu({
    required this.foods,
    required this.drinks
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      foods: json["foods"] != null
        ? List<Food>.from(json["foods"]!.map((foodJson) => Food.fromJson(foodJson)))
        : <Food>[],
      drinks: json["drinks"] != null
        ? List<Drink>.from(json["drinks"]!.map((drinkJson) => Drink.fromJson(drinkJson)))
        : <Drink>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foods': foods.map((food) => food.toJson()).toList(),
      'drinks': drinks.map((drink) => drink.toJson()).toList(),
    };
  }
}