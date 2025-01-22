import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'styles/base_color_styles.dart';

/*
|--------------------------------------------------------------------------
| Dark Theme
|--------------------------------------------------------------------------
*/

ThemeData darkTheme(BaseColorStyles color) {
  TextTheme darkTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 57.0,
        fontWeight: FontWeight.w800,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // For the largest text in your app.
    displayMedium: TextStyle(
        fontSize: 45.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Large text, slightly smaller than displayLarge.
    displaySmall: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Smaller than displayMedium but larger than headlines.
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Large headlines.
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Medium headlines.
    headlineSmall: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Small headlines.
    titleLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Large titles.
    titleMedium: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Gilroy',
        color: color.primaryAccent,
        fontWeight: FontWeight.bold), // Medium titles.
    titleSmall: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Small titles.
    bodyLarge: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Large body text.
    bodyMedium: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Medium body text.
    bodySmall: TextStyle(
        fontSize: 12.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Small body text.
    labelLarge: TextStyle(
        fontSize: 14.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Large labels.
    labelMedium: TextStyle(
        fontSize: 12.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Medium labels.
    labelSmall: TextStyle(
        fontSize: 10.0,
        fontFamily: 'Gilroy',
        color: color.primaryContent), // Small labels.
  );

  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Gilroy',
    scaffoldBackgroundColor: color.background,
    primaryColor: color.primaryAccent,
    appBarTheme: AppBarTheme(
      backgroundColor: color.appBarBackground,
      foregroundColor: color.appBarPrimaryContent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
    ),
    textTheme: darkTheme,
    iconTheme: IconThemeData(
      color: color.primaryContent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.buttonBackground,
        foregroundColor: color.buttonPrimaryContent,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: color.bottomTabBarBackground,
      selectedItemColor: color.bottomTabBarIconSelected,
      unselectedItemColor: color.bottomTabBarIconUnselected,
      selectedLabelStyle: TextStyle(color: color.bottomTabBarLabelSelected),
      unselectedLabelStyle: TextStyle(color: color.bottomTabBarLabelUnselected),
    ),
    cardTheme: CardTheme(
      color: color.surfaceBackground,
      elevation: 4,
    ),
    dividerTheme: DividerThemeData(
      color: color.primaryContent.withOpacity(0.12),
    ),
  );
}
