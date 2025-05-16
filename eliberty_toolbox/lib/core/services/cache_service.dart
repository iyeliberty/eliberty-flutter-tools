import 'dart:convert';

import 'package:eliberty_toolbox/core/storage/storable_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences prefs;
  const CacheService(this.prefs);
  // For simple String
  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<void> removeKey(String key) async {
    await prefs.remove(key);
  }

  // For storing any object (ex: UserModel) as JSON
  Future<void> writeModel(String key, StorableModel model) async {
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString(key, jsonString);
  }

  Map<String, dynamic>? readModel(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }
}
