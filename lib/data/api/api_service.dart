import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/response/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/response/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/response/restaurant_search_response.dart';

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return RestaurantListResponse.fromJson(body);
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }
  
  Future<RestaurantDetailResponse> getRestaurantDetail(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return RestaurantDetailResponse.fromJson(body);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
  
  Future<RestaurantSearchResponse> searchRestaurant(String query) async {
    final response = await http.get((Uri.parse("$_baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return RestaurantSearchResponse.fromJson(body);
    } else {
    throw Exception('Failed to load restaurant search list');
    }
  }
}