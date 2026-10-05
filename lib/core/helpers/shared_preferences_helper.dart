import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final Logger _logger;
  SharedPreferences? _prefs;

  SharedPreferencesHelper(this._logger);

  /// Call this before using the helper
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e, stacktrace) {
      _logger.e(
        'Failed to initialize SharedPreferences',
        error: e,
        stackTrace: stacktrace,
      );
    }
  }

  /// Ensure prefs is initialized
  SharedPreferences get _safePrefs {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ---------------- Language ----------------
  String getLanguageCode() => _safePrefs.getString('languageCode') ?? 'en';

  Future<void> setLanguageCode(String code) async {
    await _safeWrite(
      () => _safePrefs.setString('languageCode', code),
      'Failed to store language code',
    );
  }

  // ---------------- Theme ----------------
  String? getTheme() => _safePrefs.getString('themeMode');

  Future<void> setTheme(String theme) async {
    await _safeWrite(
      () => _safePrefs.setString('themeMode', theme),
      'Failed to store theme mode',
    );
  }

  // ---------------- User ----------------
  Future<void> storeUser(Map<String, dynamic> user) async {
    final futures = user.entries.map((entry) {
      return storeString(entry.key, entry.value.toString());
    }).toList();

    await Future.wait(futures);
  }

  // ---------------- Generic Setters/Getters ----------------
  Future<bool> storeString(String key, String value) async {
    return await _safeWrite(
      () => _safePrefs.setString(key, value),
      'Failed to store string',
    );
  }

  Future<bool> storeBool(String key, bool value) async {
    return await _safeWrite(
      () => _safePrefs.setBool(key, value),
      'Failed to store bool',
    );
  }

  Future<bool> storeInt(String key, int value) async {
    return await _safeWrite(
      () => _safePrefs.setInt(key, value),
      'Failed to store int',
    );
  }

  Future<bool> storeDouble(String key, double value) async {
    return await _safeWrite(
      () => _safePrefs.setDouble(key, value),
      'Failed to store double',
    );
  }

  String? getString(String key) => _safePrefs.getString(key);

  bool? getBool(String key) => _safePrefs.getBool(key);

  int? getInt(String key) => _safePrefs.getInt(key);

  double? getDouble(String key) => _safePrefs.getDouble(key);

  // ---------------- Clear ----------------
  Future<bool> clearAllData() async {
    return await _safeWrite(() => _safePrefs.clear(), 'Failed to clear data');
  }

  // ---------------- Safe Write ----------------
  Future<bool> _safeWrite(
    Future<bool> Function() operation,
    String errorMessage,
  ) async {
    try {
      return await operation();
    } catch (e, stacktrace) {
      _logger.e(errorMessage, error: e, stackTrace: stacktrace);
      return false;
    }
  }
}
