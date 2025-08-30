import 'package:flutter/material.dart';
import '../../../../../model/app_user.dart';
import '../../../utils/dialog_utils.dart';
import '../register/register_screen.dart';
import '../../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextFormField(
              onChanged: (text) => email = text,
              decoration: const InputDecoration(label: Text("Email")),
            ),
            const SizedBox(height: 8),
            TextFormField(
              onChanged: (text) => password = text,
              obscureText: true,
              decoration: const InputDecoration(label: Text("Password")),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
                onPressed: loginLocally,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    children: [
                      Text("Login", style: TextStyle(fontSize: 18)),
                      Spacer(),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                )),
            const SizedBox(height: 18),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RegisterScreen.routeName);
              },
              child: const Text(
                "Create account",
                style: TextStyle(fontSize: 18, color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginLocally() async {
    AppUser? user = await AppUser.getUserFromLocal();
    if (user != null && user.email == email && user.password == password) {
      AppUser.currentUser = user;
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      DialogUtils.showError(context, "Invalid email or password");
    }
  }
}
