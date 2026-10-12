import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Film.dart';

/// Manages the cart using SharedPreferences (works on Android, iOS, Web, Desktop).
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const String _cartKey = 'cart_items';

  /// Retrieve all films from the cart.
  Future<List<Film>> getCartFilms() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_cartKey) ?? [];
    int index = 0;
    return jsonList.map((jsonStr) {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      // Assign a pseudo id based on list position if not present
      map['id'] ??= index;
      index++;
      return Film.fromMap(map);
    }).toList();
  }

  /// Insert a film into the cart.
  Future<void> insertFilm(Film film) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_cartKey) ?? [];
    // Assign a unique id based on timestamp
    final map = film.toMap();
    map['id'] = DateTime.now().millisecondsSinceEpoch;
    jsonList.add(jsonEncode(map));
    await prefs.setStringList(_cartKey, jsonList);
  }

  /// Delete a film by its id.
  Future<void> deleteFilm(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_cartKey) ?? [];
    jsonList.removeWhere((jsonStr) {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return map['id'] == id;
    });
    await prefs.setStringList(_cartKey, jsonList);
  }

  /// Remove all items from the cart.
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
