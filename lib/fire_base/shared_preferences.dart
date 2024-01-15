import 'dart:convert';

import 'package:project_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController {
  static Future<void> saveUserInfo(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(user.toJson());
    await prefs.setString('user', json);
  }

  static Future<UserModel?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null && prefs.getString('user') != "") {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('user')!);
      return UserModel.fromJson(userMap);
    } else {
      return null;
    }
  }

  static resetUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', "");
  }
}
