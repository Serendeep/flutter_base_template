import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  SharedPreferences? _preferences;

  // Private constructor
  SharedPrefs._internal();

  // Factory constructor to return the singleton instance
  factory SharedPrefs() {
    return _instance;
  }

  // Initialize SharedPreferences
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save a String value
  Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Get a String value
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save an int value
  Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // Get an int value
  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // Save a bool value
  Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Get a bool value
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Save a double value
  Future<void> setDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  // Get a double value
  double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  // Save a list of strings
  Future<void> setStringList(String key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  // Get a list of strings
  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  // Remove a key
  Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    await _preferences?.clear();
  }
}
