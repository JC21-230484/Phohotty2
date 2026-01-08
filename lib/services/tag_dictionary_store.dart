import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TagDictionaryStore {
  static const _key = 'tag_dictionary_ja';

  static Future<Map<String, String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return {};

    return Map<String, String>.from(json.decode(jsonStr));
  }

  static Future<void> save(Map<String, String> dictionary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(dictionary));
  }
}
