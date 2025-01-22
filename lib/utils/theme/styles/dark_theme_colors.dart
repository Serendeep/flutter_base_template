import 'package:flutter/material.dart';
import 'base_color_styles.dart';

/*
|--------------------------------------------------------------------------
| Dark Theme Colors
|--------------------------------------------------------------------------
*/

class DarkThemeColors implements BaseColorStyles {
  // general
  @override
  Color get background => const Color(0xFF121212);

  @override
  Color get primaryContent => const Color(0xFFFFFFFF);
  @override
  Color get primaryAccent => const Color(0xFFBB86FC);

  @override
  Color get surfaceBackground => const Color(0xFF1E1E1E);
  @override
  Color get surfaceContent => Colors.white;

  // app bar
  @override
  Color get appBarBackground => const Color(0xFF1E1E1E);
  @override
  Color get appBarPrimaryContent => Colors.white;

  // buttons
  @override
  Color get buttonBackground => const Color(0xFFBB86FC);
  @override
  Color get buttonPrimaryContent => Colors.black;

  // bottom tab bar
  @override
  Color get bottomTabBarBackground => const Color(0xFF1E1E1E);

  // bottom tab bar - icons
  @override
  Color get bottomTabBarIconSelected => const Color(0xFFBB86FC);
  @override
  Color get bottomTabBarIconUnselected => Colors.white54;

  // bottom tab bar - label
  @override
  Color get bottomTabBarLabelUnselected => Colors.white54;
  @override
  Color get bottomTabBarLabelSelected => Colors.white;

  // Input Decorator Colors
  @override
  Color get inputFillColor => const Color(0xFF2C2C2C);
  @override
  Color get inputErrorLabelColor => const Color(0xFFCF6679);
  @override
  Color get inputFocusedLabelColor => const Color(0xFFBB86FC);
  @override
  Color get inputDefaultLabelColor => Colors.white54;
  @override
  Color get selectedValuesTextColor => Colors.white;
  @override
  Color get textfieldBorderColor => Colors.white24;
  @override
  Color get labelTextColor => Colors.white70;
}
