import 'package:flutter/material.dart';
import 'package:flutter_base_template/services/db/database_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/modules/home/bloc/home_bloc.dart';
import 'package:flutter_base_template/utils/config/bloc_dispatcher.dart';
import 'package:flutter_base_template/utils/config/app_config.dart';
import 'package:flutter_base_template/utils/shared_prefs.dart';
import 'package:flutter_base_template/utils/theme/theme.dart';
import 'package:flutter_base_template/routes/app_router.dart';
import 'package:flutter_base_template/utils/config/flavor_banner.dart';
import 'package:theme_provider/theme_provider.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final blocDispatcher = BlocDispatcher();
  Bloc.observer = blocDispatcher;

  await Future.wait([
    SharedPrefs().init(),
    DatabaseService.instance.initHive(),
    AppConfig().init(),
  ]);

  // TODO: Implement Push Notification Service
  // Initialize push notifications if enabled
  // if (AppConfig.enablePushNotifications) {
  //   try {
  //     final pushService =
  //         PushNotificationService.initialize(blocDispatcher: blocDispatcher);
  //     await pushService.init();
  //   } on Exception catch (e) {
  //     Logger().e(
  //         'Supabase Push Notification Initialization Error: ${e.toString()}');
  //   } catch (e) {
  //     Logger().e('Unexpected error initializing push notifications: $e');
  //   }
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<AppTheme> appTheme = appThemes
        .map<AppTheme>((localTheme) => localTheme.toAppTheme())
        .toList();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: appTheme,
        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => HomeBloc()),
              ],
              child: FlavorBanner(
                child: MaterialApp.router(
                  title: AppConfig.appTitle,
                  theme: ThemeProvider.themeOf(themeContext).data,
                  routerConfig: AppRouter.router,
                  debugShowCheckedModeBanner: !AppConfig.isProduction,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
