import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  static AppUser? currentUser;
  late String id;
  late String email;
  late String username;
  late String password;

  AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
  });

  AppUser.fromJson(Map json) {
    id = json["id"];
    email = json["email"];
    username = json["username"];
    password = json["password"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "username": username,
      "password": password,
    };
  }

  String toJsonString() => json.encode(toJson());

  static Future<void> saveUserLocally(AppUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("current_user", user.toJsonString());
    currentUser = user;
  }

  static Future<AppUser?> getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("current_user");
    if (userString == null) return null;
    currentUser = AppUser.fromJson(json.decode(userString));
    return currentUser;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("current_user");
    currentUser = null;
  }
}
