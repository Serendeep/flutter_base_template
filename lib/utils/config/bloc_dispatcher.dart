import 'package:flutter_base_template/utils/config/flavor_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

//Dispatcher to Dispatch Blocs Based on Status and Screen from a Notification

class BlocDispatcher extends BlocObserver {
  final Logger _logger = Logger();
  final bool _enableLogging;

  BlocDispatcher({bool? enableLogging})
      : _enableLogging =
            enableLogging ?? FlavorConfig.instance.values.enableLogging;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (_enableLogging) {
      _logger.d('onCreate -- ${bloc.runtimeType}');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (_enableLogging) {
      _logger.d('onEvent -- ${bloc.runtimeType}, $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (_enableLogging) {
      _logger.d('onChange -- ${bloc.runtimeType}, $change');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (_enableLogging) {
      _logger.d('onTransition -- ${bloc.runtimeType}, $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (_enableLogging) {
      _logger.e('onError -- ${bloc.runtimeType}');
      _logger.e(error);
      _logger.e(stackTrace);
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (_enableLogging) {
      _logger.d('onClose -- ${bloc.runtimeType}');
    }
  }

  // Method to handle push notification events
  void handleNotification(Map<String, dynamic> message) {
    try {
      final String? type = message['type'];
      final String? action = message['action'];
      final Map<String, dynamic>? data = message['data'];

      if (type == null || action == null) {
        _logger.w('Invalid notification format: missing type or action');
        return;
      }

      _logger
          .d('Handling notification: type=$type, action=$action, data=$data');

      // Add your notification handling logic here
    } catch (e, stackTrace) {
      _logger.e('Error handling notification');
      _logger.e(e);
      _logger.e(stackTrace);
    }
  }
}
