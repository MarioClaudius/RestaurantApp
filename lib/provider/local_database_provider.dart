import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/services/sqlite_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final SqliteService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<Restaurant>? _favoriteRestaurantList;
  List<Restaurant>? get favoriteRestaurantList => _favoriteRestaurantList;

  Restaurant? _favoriteRestaurant;
  Restaurant? get favoriteRestaurant => _favoriteRestaurant;

  bool? _isFavoriteRestaurant;
  bool? get isFavoriteRestaurant => _isFavoriteRestaurant;

  Future<void> saveFavoriteRestaurant(Restaurant value) async {
    try {
      final result = await _service.insertFavoriteRestaurant(value);
      final isError = result == 0;
      if (isError) {
        _message = "Failed to save restaurant to favorite";
      } else {
        _message = "Restaurant saved to favorite";
      }
      notifyListeners();
    } catch (e) {
      _message = "Failed to save restaurant to favorite";
      notifyListeners();
    }
  }

  Future<void> loadAllFavoriteRestaurants() async {
    try {
      _favoriteRestaurantList = await _service.getAllFavoriteRestaurant();
      _message = "Favorite restaurants loaded successfully";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load favorite restaurants";
      notifyListeners();
    }
  }

  Future<void> loadFavoriteRestaurantById(String id) async {
    try {
      _favoriteRestaurant = await _service.getFavoriteRestaurantById(id);
      _message = "Favorite restaurant is loaded successfully";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load favorite restaurant";
      notifyListeners();
    }
  }

  Future<void> removeFavoriteRestaurant(String id) async {
    try {
      await _service.removeFavoriteRestaurant(id);
      _message = "Favorite restaurant is removed successfully";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove favorite restaurant";
      notifyListeners();
    }
  }

  Future<void> checkRestaurantIsFavorite(String id) async {
    try {
      _isFavoriteRestaurant = await _service.checkRestaurantIsFavorite(id);
      notifyListeners();
    } catch (e) {
      _message = "Failed to check favorite restaurant";
      notifyListeners();
    }
  }
}