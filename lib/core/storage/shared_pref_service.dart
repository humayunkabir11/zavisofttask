import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  SharedPrefService._internal();

  static final SharedPrefService _instance =
  SharedPrefService._internal();

  factory SharedPrefService() => _instance;

  late SharedPreferences _prefs;

  /// Call this in `main()` before runApp()
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ================== SET ==================

  Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  Future<bool> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  // ================== GET ==================

  String? getString(String key) => _prefs.getString(key);

  int? getInt(String key) => _prefs.getInt(key);

  bool? getBool(String key) => _prefs.getBool(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  List<String>? getStringList(String key) =>
      _prefs.getStringList(key);

  // ================== REMOVE / CLEAR ==================

  Future<bool> remove(String key) async =>
      await _prefs.remove(key);

  Future<bool> clear() async =>
      await _prefs.clear();

  // ================== UTIL ==================

  bool containsKey(String key) =>
      _prefs.containsKey(key);
}
