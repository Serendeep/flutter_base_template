import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klackr_mobile/modules/home/bloc/home_bloc.dart';
import 'package:klackr_mobile/services/push_notification_service.dart';
import 'package:klackr_mobile/utils/bloc_dispatcher.dart';
import 'package:klackr_mobile/utils/networking/app_config.dart';
import 'package:klackr_mobile/utils/shared_prefs.dart';
import 'package:klackr_mobile/utils/theme/theme.dart';
import 'package:theme_provider/theme_provider.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await SharedPrefs().init();
  final homeBloc = HomeBloc();

  final BlocDispatcher blocDispatcher = BlocDispatcher(
      //   homeBloc: homeBloc,
      );

  // Initialize the PushNotificationService
  final PushNotificationService pushNotificationService =
      PushNotificationService(blocDispatcher);

  // final orderBloc = OrderBloc(pushNotificationService);
  // blocDispatcher.orderBloc = orderBloc;

  // AppConfig.environment = Environment.prod;
  AppConfig.environment = Environment.dev;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => homeBloc),
      ],
      child: KlackrMobileApp(pushNotificationService: pushNotificationService),
    ),
  );
}

class KlackrMobileApp extends StatelessWidget {
  final PushNotificationService _notificationService;
  const KlackrMobileApp(
      {super.key, required PushNotificationService pushNotificationService})
      : _notificationService = pushNotificationService;

  @override
  Widget build(BuildContext context) {
    _notificationService.initialize();
    _notificationService.subscribeToTopic('all');
    List<AppTheme> appTheme = appThemes
        .map<AppTheme>((localTheme) => localTheme.toAppTheme())
        .toList();
    return ThemeProvider(
      themes: appTheme,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Klackr',
              theme: ThemeProvider.themeOf(themeContext).data,
              restorationScopeId: 'klackr_app',
              routerConfig: AppRouter().router,
            );
          },
        ),
      ),
    );
  }
}
