import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceModule {
  static const String userInfoKey = 'userInfo';

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    try {
      // Chuyển đổi map thành chuỗi JSON
      String jsonUserInfo = jsonEncode(userInfo);

      // Lưu chuỗi JSON vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(userInfoKey, jsonUserInfo);
    } catch (e) {
      print('Lỗi từ Sharepreference: $e');
    }
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonUserInfo = prefs.getString(userInfoKey);

      if (jsonUserInfo != null) {
        Map<String, dynamic> userInfo = jsonDecode(jsonUserInfo);
        return userInfo;
      }
    } catch (e) {
      print('Lỗi Sharepreference : $e');
    }
    return {};
  }

  Future<void> clearUserInfo() async {
    try {
      // Xóa thông tin người dùng từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(userInfoKey);
    } catch (e) {
      print('Lỗi Sharepreference : $e');
    }
  }
}
