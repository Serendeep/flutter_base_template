import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_base_template/modules/home/views/home_page.dart';
// Example:
// import 'package:flutter_base_template/modules/profile/views/profile_page.dart';
// import 'package:flutter_base_template/modules/settings/views/settings_page.dart';
import 'package:flutter_base_template/routes/app_routes.dart';

class AppRouter {
  // Navigator keys
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  // Centralized router configuration
  static final GoRouter _router = GoRouter(
    navigatorKey: parentNavigatorKey,
    debugLogDiagnostics: true,

    // Global error page handler
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),

    // Define routes
    routes: [
      GoRoute(
        name: Routes.home,
        path: Routes.homeRoute,
        builder: (context, state) => const HomePage(),
      ),
      // Example:
      // GoRoute(
      //   name: Routes.profile,
      //   path: Routes.profileRoute,
      //   builder: (context, state) => const ProfilePage(),
      // ),
      // GoRoute(
      //   name: Routes.settings,
      //   path: Routes.settingsRoute,
      //   builder: (context, state) => const SettingsPage(),
      // ),
    ],
  );

  // Getter for router
  static GoRouter get router => _router;

  // Optional: Method to handle programmatic navigation
  static void navigateTo(BuildContext context, String routeName,
      {Object? extra}) {
    context.goNamed(routeName, extra: extra);
  }
}
