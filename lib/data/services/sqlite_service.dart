import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'favoriteRestaurantlist.db';
  static const String _tableName = 'favorite_restaurant';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
      """CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY UNIQUE NOT NULL,
        favorite_restaurant_json_data TEXT NOT NULL
      )
      """
    );
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertFavoriteRestaurant(Restaurant restaurant) async {
    final db = await _initializeDb();
    final data = restaurant.toRecordJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Restaurant>> getAllFavoriteRestaurant() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "id");
    return results.map((result) => Restaurant.fromRecordJson(result)).toList();
  }

  Future<Restaurant> getFavoriteRestaurantById(String id) async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, where: "id = ?", whereArgs: [id], limit: 1);
    return results.map((result) => Restaurant.fromRecordJson(result)).first;
  }

  Future<int> removeFavoriteRestaurant(int id) async {
    final db = await _initializeDb();
    final result = await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }
}