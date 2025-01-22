import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Base Template Home'),
        actions: [
          IconButton(
            icon: Icon(
              ThemeProvider.themeOf(context).id == 'lightthemeid'
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () {
              // Toggle between light and dark themes
              final currentThemeId = ThemeProvider.themeOf(context).id;
              final newThemeId = currentThemeId == 'lightthemeid'
                  ? 'darkthemeid'
                  : 'lightthemeid';

              ThemeProvider.controllerOf(context).setTheme(newThemeId);
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Flutter Base Template!'),
            SizedBox(height: 20),
            Text('Toggle theme using the icon in the app bar'),
          ],
        ),
      ),
    );
  }
}
