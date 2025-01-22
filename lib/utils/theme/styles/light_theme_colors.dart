import 'package:flutter/material.dart';
import 'base_color_styles.dart';

/*
|--------------------------------------------------------------------------
| Light Theme Colors
|--------------------------------------------------------------------------
*/

class LightThemeColors implements BaseColorStyles {
  // general
  @override
  Color get background => const Color(0xFFFFFFFF);

  @override
  Color get primaryContent => const Color(0xFF000000);
  @override
  Color get primaryAccent => const Color(0xffB3142E);

  @override
  Color get surfaceBackground => Colors.white;
  @override
  Color get surfaceContent => Colors.black;

  // app bar
  @override
  Color get appBarBackground => const Color(0xffB3142E);
  @override
  Color get appBarPrimaryContent => Colors.white;

  // buttons
  @override
  Color get buttonBackground => const Color(0xffB3142E);
  @override
  Color get buttonPrimaryContent => Colors.white;

  // bottom tab bar
  @override
  Color get bottomTabBarBackground => Colors.white;

  // bottom tab bar - icons
  @override
  Color get bottomTabBarIconSelected => const Color(0xffB3142E);
  @override
  Color get bottomTabBarIconUnselected => Colors.black54;

  // bottom tab bar - label
  @override
  Color get bottomTabBarLabelUnselected => Colors.black45;
  @override
  Color get bottomTabBarLabelSelected => Colors.black;

  // InputDecorator
  @override
  Color get inputFillColor => const Color(
      0xffF5F4F9); // Color(0xFFE1E1E1); // This is a light grey for light theme.
  @override
  Color get inputErrorLabelColor => Colors.red;
  @override
  Color get inputFocusedLabelColor => Colors.green;
  @override
  Color get inputDefaultLabelColor =>
      const Color(0xFF000000); // This matches the primaryContent color.
  @override
  Color get selectedValuesTextColor =>
      const Color(0xFF000000); // Black for light theme.
  @override
  Color get textfieldBorderColor => const Color(0xffB3142E).withAlpha(89);
  @override
  Color get labelTextColor =>
      const Color(0xff999999); // Label text color for light theme.
}
