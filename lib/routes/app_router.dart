import 'package:klackr_mobile/modules/home/views/home_page.dart';

import 'app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> menuNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GoRouter _router =
      GoRouter(navigatorKey: parentNavigatorKey, routes: [
    GoRoute(
      name: Routes.home,
      path: '/',
      builder: (BuildContext context, GoRouterState state) => HomePage(),
    ),
  ]);

  GoRouter get router => _router;
}
