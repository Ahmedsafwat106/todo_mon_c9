import 'package:flutter/material.dart';
import 'package:todo_mon_c9/ui/utils/app_colors.dart';

abstract class AppTheme {
  static const TextStyle appBarTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: AppColors.white,
  );

  static const TextStyle taskTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: AppColors.primiary,
  );

  static const TextStyle taskDescriptionTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.lightBlack,
  );

  static const TextStyle bottomSheetTitleTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: AppColors.black,
  );

  /// 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primiary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primiary,
      elevation: 0,
      titleTextStyle: appBarTextStyle,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(size: 32),
      unselectedIconTheme: IconThemeData(size: 32),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppColors.primiary,
      unselectedItemColor: AppColors.grey,
    ),
    scaffoldBackgroundColor: AppColors.accent,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: StadiumBorder(
        side: BorderSide(color: AppColors.white, width: 4),
      ),
    ),
  );

  /// 🌚 Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primiary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: appBarTextStyle,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(size: 32),
      unselectedIconTheme: IconThemeData(size: 32),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppColors.primiary,
      unselectedItemColor: AppColors.grey,
      backgroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primiary,
      shape: StadiumBorder(
        side: BorderSide(color: Colors.white, width: 4),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
