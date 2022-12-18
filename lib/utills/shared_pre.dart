import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String keyLocation = 'keyLocation';

class SharedPre {
  ///Keys
  static const loginUser = 'loginUser';
  static const isLogin = 'isLogin';

  static Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  static getStringValue(String key, {String defaultValue = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<bool> getBoolValue(String key,
      {bool defaultValue = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static getIntValue(String key, {int defaultValue = -1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<bool> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  /// call this method like this
  ///  LoginData data=LoginData.fromJson(loginresponse.data.tojson())
  /// sp.setObj("",data);
  static setObj(String key, var toJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = jsonEncode(toJson);
    return await prefs.setString(key, user);
  }

  /// call this method like this
  ///var data= sp.getObj("key);
  ///Login loginData= Logindata.fromjson(data);
  static Future<Map<String, dynamic>> getObj(String key) async {
    Map<String, dynamic> json = {};
    if (key.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String str = prefs.getString(key) ?? "";
      if (str.isNotEmpty) {
        json = jsonDecode(str);
      }
      json;
    }
    return json;
  }
}
