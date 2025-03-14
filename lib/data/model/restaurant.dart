import 'package:restaurant_app/data/model/category.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/menu.dart';
import 'dart:convert';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String? address;
  final String pictureId;
  final List<Category> categories;
  final Menu? menus;
  final double rating;
  final List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      categories: json["categories"] != null
        ? List<Category>.from(json["categories"]!.map((categoryJson) => Category.fromJson(categoryJson)))
        : <Category>[],
      menus: json["menus"] != null
        ? Menu.fromJson(json["menus"])
        : null,
      rating: double.parse(json["rating"].toString()),
      customerReviews: json["customerReviews"] != null
        ? List<CustomerReview>.from(json["customerReviews"]!.map((customerReviewJson) => CustomerReview.fromJson(customerReviewJson)))
        : <CustomerReview>[],
    );
  }

  factory Restaurant.fromRecordJson(Map<String, dynamic> recordJson) {
    Map<String, dynamic> decodedFavoriteRestaurant = jsonDecode(recordJson['favorite_restaurant_json_data']);
    return Restaurant.fromJson(decodedFavoriteRestaurant);
  }

  Map<String, dynamic> toRecordJson() {
    return <String, dynamic>{
      'id': id,
      'favorite_restaurant_json_data': jsonEncode(toJson()),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'address': address,
      'pictureId': pictureId,
      'categories': categories.map((category) => category.toJson()).toList(),
      'menus': menus?.toJson(),
      'rating': rating,
      'customerReviews': customerReviews.map((customerReview) => customerReview.toJson()).toList(),
    };
  }
}