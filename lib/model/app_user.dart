import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  static AppUser? currentUser;
  late String id;
  late String email;
  late String username;

  AppUser({required this.id, required this.email, required this.username});

  AppUser.fromJson(Map json) {
    id = json["id"];
    email = json["email"];
    username = json["username"];
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "email": email, "username": username};
  }

  static Future<void> saveUserLocally(AppUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("current_user", json.encode(user.toJson()));
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
    prefs.remove("current_user");
    currentUser = null;
  }
}
