import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/response/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService apiService;
  late RestaurantListProvider restaurantListProvider;
  final successResult = RestaurantListResponse(
    error: false,
    message: "success",
    count: 1,
    restaurants: [
      Restaurant(
        id: "id",
        name: "name",
        description: "description",
        city: "city",
        address: "address",
        pictureId: "pictureId",
        categories: [],
        menus: null,
        rating: 0.0,
        customerReviews: [],
      ),
    ],
  );
  final failResult = RestaurantListResponse(
    error: true,
    message: "error",
    count: 0,
    restaurants: [],
  );

  setUp(() {
    apiService = MockApiService();
    restaurantListProvider = RestaurantListProvider(apiService);
  });
  
  group("restaurant list provider", () {
    test('resultState should return RestaurantListNoneState object when provider initialize', () {
      final initState = restaurantListProvider.resultState;
      expect(initState, isA<RestaurantListNoneState>());
    });
    
    test("should return restaurant list if api fetch is success", () async {
      when(() => apiService.getRestaurantList())
          .thenAnswer((_) async => successResult);
      final future = restaurantListProvider.fetchRestaurantList();
      expect(restaurantListProvider.resultState, isA<RestaurantListLoadingState>());
      await future;
      expect(restaurantListProvider.resultState, isA<RestaurantListLoadedState>());
      final loadedState = restaurantListProvider.resultState as RestaurantListLoadedState;
      expect(loadedState.data, successResult.restaurants);
    });

    test("should return error message if api fetch is failed", () async {
      when(() => apiService.getRestaurantList())
          .thenAnswer((_) async => failResult);
      final future = restaurantListProvider.fetchRestaurantList();
      expect(restaurantListProvider.resultState, isA<RestaurantListLoadingState>());
      await future;
      expect(restaurantListProvider.resultState, isA<RestaurantListErrorState>());
      final errorState = restaurantListProvider.resultState as RestaurantListErrorState;
      expect(errorState.error, failResult.message);
    });
  });
}