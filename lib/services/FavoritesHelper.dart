import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Film.dart';

/// Manages favorites using SharedPreferences (works on Android, iOS, Web, Desktop).
class FavoritesHelper {
  static final FavoritesHelper _instance = FavoritesHelper._internal();
  factory FavoritesHelper() => _instance;
  FavoritesHelper._internal();

  static const String _favKey = 'favorite_items';

  /// Returns all favorite films.
  Future<List<Film>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favKey) ?? [];
    return jsonList.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return Film.fromMap(map);
    }).toList();
  }

  /// Returns true if the film (matched by title) is already a favorite.
  Future<bool> isFavorite(String title) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.title == title);
  }

  /// Adds a film to favorites. Does nothing if already present.
  Future<void> addFavorite(Film film) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favKey) ?? [];
    final alreadyExists = jsonList.any((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return map['title'] == film.title;
    });
    if (!alreadyExists) {
      final map = film.toMap();
      map['id'] = DateTime.now().millisecondsSinceEpoch;
      jsonList.add(jsonEncode(map));
      await prefs.setStringList(_favKey, jsonList);
    }
  }

  /// Removes a film from favorites by title.
  Future<void> removeFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favKey) ?? [];
    jsonList.removeWhere((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return map['title'] == title;
    });
    await prefs.setStringList(_favKey, jsonList);
  }
}
