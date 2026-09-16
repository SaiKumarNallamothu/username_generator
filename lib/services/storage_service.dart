import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late Box _box;
  static late SharedPreferences _prefs;

  static Future<void> init([String? path]) async {
    if (path != null) {
      Hive.init(path);
    } else {
      await Hive.initFlutter();
    }
    _box = await Hive.openBox('username_generator_box');
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Favorites ---
  static List<String> getFavorites() {
    return List<String>.from(_box.get('favorites', defaultValue: <String>[]));
  }

  static Future<void> saveFavorite(String name) async {
    final favorites = getFavorites();
    if (!favorites.contains(name)) {
      favorites.insert(0, name);
      await _box.put('favorites', favorites);
    }
  }

  static Future<void> removeFavorite(String name) async {
    final favorites = getFavorites();
    if (favorites.contains(name)) {
      favorites.remove(name);
      await _box.put('favorites', favorites);
    }
  }

  // --- History ---
  static List<String> getHistory() {
    return List<String>.from(_box.get('history', defaultValue: <String>[]));
  }

  static Future<void> addHistory(String name) async {
    final history = getHistory();
    // Move to front if exists, or insert
    history.remove(name);
    history.insert(0, name);
    // Limit history to 50 items
    if (history.length > 50) {
      history.removeLast();
    }
    await _box.put('history', history);
  }

  static Future<void> clearHistory() async {
    await _box.put('history', <String>[]);
  }

  // --- Premium Simulation ---
  static bool isPremium() {
    return _prefs.getBool('is_premium') ?? false;
  }

  static Future<void> setPremium(bool val) async {
    await _prefs.setBool('is_premium', val);
  }
}
