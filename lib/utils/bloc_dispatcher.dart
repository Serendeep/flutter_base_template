import 'package:klackr_mobile/routes/app_router.dart';
import 'package:logger/logger.dart';

//Dispatcher to Dispatch Blocs Based on Status and Screen from a Notification

class BlocDispatcher {
  final Logger logger = Logger();
  AppRouter get _router => AppRouter();

  BlocDispatcher();

  void dispatchBlocEvent(Map<String, dynamic> messageData) {
    final String status = messageData['status'] ?? '';
    final String screen = messageData['screen'] ?? '';

    logger.d('Dispatching event with status: $status, screen: $screen');

    switch (screen) {
      default:
        logger.w('Unhandled screen: $screen with status: $status');
    }
  }
}
