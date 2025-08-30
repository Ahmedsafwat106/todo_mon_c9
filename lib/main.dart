import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mon_c9/providers/list_provider.dart';
import 'package:todo_mon_c9/services/notification_service.dart'; // 🟢 استدعاء السيرفس
import 'package:todo_mon_c9/ui/screens/auth/login/login_screen.dart';
import 'package:todo_mon_c9/ui/screens/auth/register/register_screen.dart';
import 'package:todo_mon_c9/ui/screens/home/home_screen.dart';
import 'package:todo_mon_c9/ui/screens/home/tabs/settings/settings_tab.dart';
import 'package:todo_mon_c9/ui/screens/splash/splash_screen.dart';
import 'package:todo_mon_c9/ui/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🟢 تهيئة Notifications قبل تشغيل التطبيق
  await NotificationService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ListProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // 🟢 بقى فيه dark theme
      themeMode: ThemeMode.system,   // 🟢 يغير حسب إعدادات الموبايل
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(), // 🟢
        "/settings": (_) => const SettingsTab(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}

