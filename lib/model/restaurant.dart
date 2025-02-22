import 'package:restaurant_app/model/category.dart';
import 'package:restaurant_app/model/customer_review.dart';
import 'package:restaurant_app/model/menu.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menu menus;
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
      menus: Menu.fromJson(json["menus"]),
      rating: json["rating"],
      customerReviews: json["customerReviews"] != null
        ? List<CustomerReview>.from(json["customerReviews"]!.map((customerReviewJson) => CustomerReview.fromJson(customerReviewJson)))
        : <CustomerReview>[],
    );
  }
}