import 'package:flutter/material.dart';
import '../../../../../model/app_user.dart';
import '../../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = "";
  String password = "";
  String username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextFormField(
              onChanged: (text) => username = text,
              decoration: const InputDecoration(label: Text("Username")),
            ),
            TextFormField(
              onChanged: (text) => email = text,
              decoration: const InputDecoration(label: Text("Email")),
            ),
            TextFormField(
              onChanged: (text) => password = text,
              obscureText: true,
              decoration: const InputDecoration(label: Text("Password")),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
                onPressed: registerLocally,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    children: [
                      Text("Create account", style: TextStyle(fontSize: 18)),
                      Spacer(),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void registerLocally() async {
    AppUser newUser = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      username: username,
      password: password,
    );
    await AppUser.saveUserLocally(newUser);
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }
}
