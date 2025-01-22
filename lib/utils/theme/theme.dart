import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'light_theme.dart';
import 'dark_theme.dart';
import 'styles/base_color_styles.dart';
import 'styles/light_theme_colors.dart';
import 'styles/dark_theme_colors.dart';

// This theme function has been deprecated and is not being used.
// Please use the appThemes variable below instead.
ThemeData appTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    // Define the default font family.
    fontFamily: 'Gilroy',
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
      titleSmall: TextStyle(fontSize: 14.0),
    ),
  );
}

final List<BaseThemeConfig<BaseColorStyles>> appThemes = [
  BaseThemeConfig<BaseColorStyles>(
    id: 'lightthemeid',
    description: "Light theme",
    theme: lightTheme,
    colors: LightThemeColors(),
  ),
  BaseThemeConfig<BaseColorStyles>(
    id: 'darkthemeid',
    description: "Dark theme",
    theme: darkTheme,
    colors: DarkThemeColors(),
  ),
];

/// Base theme config is used for theme management
/// Set the required parameters to create new themes.
class BaseThemeConfig<T> {
  final String id;
  final String description;
  ThemeData Function(T colorStyles) theme;
  final T colors;
  final dynamic meta;

  BaseThemeConfig(
      {required this.id,
      required this.description,
      required this.theme,
      required this.colors,
      this.meta = const {}});

  AppTheme toAppTheme({ThemeData? defaultTheme}) => AppTheme(
        id: id,
        data: defaultTheme ?? theme(colors),
        description: description,
      );
}

/// Helper to get the color styles
/// Find a color style from the Nylo's [appThemes].
T getColorStyle<T>(BuildContext context, {String? themeId}) {
  List<BaseThemeConfig<T>> listOfThemes = appThemes as List<BaseThemeConfig<T>>;

  if (themeId == null) {
    BaseThemeConfig<T> themeFound = listOfThemes.firstWhere((theme) {
      final brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return theme.id == 'darkthemeid';
      }
      return theme.id == ThemeProvider.controllerOf(context).currentThemeId;
    }, orElse: () => listOfThemes.first);
    return themeFound.colors;
  }

  BaseThemeConfig<T> baseThemeConfig = listOfThemes.firstWhere(
      (theme) => theme.id == themeId,
      orElse: () => listOfThemes.first);
  return baseThemeConfig.colors;
}

class ThemeColor {
  static BaseColorStyles get(BuildContext context, {String? themeId}) =>
      getColorStyle<BaseColorStyles>(context, themeId: themeId);

  static Color fromHex(String hexColor) => getHexColor(hexColor);
}

/// Hex Color
getHexColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
