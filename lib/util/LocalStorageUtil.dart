import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtil {
  static Future<String?> getString(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(name);
  }

  static void setString(String name, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, value);
  }

  static Future<int?> getInt(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(name);
  }

  static void setInt(String name, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(name, value);
  }

  static Future<bool?> getBool(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(name);
  }

  static void setBool(String name, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(name, value);
  }

  static Future<double?> getDouble(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(name);
  }

  static void setDouble(String name, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(name, value);
  }

  static Future<List<String>?> getStringList(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(name);
  }

  static void setStringList(String name, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(name, value);
  }
}
