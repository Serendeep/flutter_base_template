// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:klackr_mobile/utils/bloc_dispatcher.dart';
import 'package:logger/logger.dart';
// import 'package:rxdart/rxdart.dart';

// final _messageStreamController = BehaviorSubject<RemoteMessage>();

class PushNotificationService {
  // final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final BlocDispatcher _blocDispatcher;
  final Logger _logger = Logger();
  final Set<String> _processedMessages = {};
  bool _listenersRegistered = false;

  PushNotificationService(this._blocDispatcher) {
    Logger().d('Initializing PushNotificationService');
    try {
      // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    } catch (e) {
      Logger().e('Error registering background message handler: $e');
    }
  }

  Future<void> initialize() async {
    if (!_listenersRegistered) {
      _listenersRegistered = true;

      // _fcm.subscribeToTopic('all');
      // _fcm.subscribeToTopic('dev');
      // NotificationSettings settings = await _fcm.requestPermission(
      //   alert: true,
      //   announcement: false,
      //   badge: true,
      //   carPlay: false,
      //   criticalAlert: false,
      //   provisional: false,
      //   sound: true,
      // );

      // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //     _handleMessage(message);
      //   });

      //   backgroundOpenApp();

      //   FirebaseMessaging.onMessageOpenedApp
      //       .listen((RemoteMessage message) async {
      //     _handleMessage(message);
      //   });

      // Get the token
      // await getToken();
      // }
    }
  }

  // void _handleMessage(RemoteMessage message) {
  //   if (_processedMessages.contains(message.messageId)) {
  //     _logger.d('Message ${message.messageId} already processed.');
  //     return;
  //   }

  //   _logger.d('Got a message whilst in the foreground!');
  //   _logger.d('Message data: ${message.data}');

  //   // Dispatching to appropriate bloc
  //   _blocDispatcher.dispatchBlocEvent(message.data);

  //   if (message.notification != null) {
  //     _logger.d(
  //         'Message also contained a notification: ${message.notification?.title}');
  //     _logger.d(
  //         'Message also contained a notification with: ${message.notification?.body}');
  //     _messageStreamController.sink.add(message);
  //   }
  //   _processedMessages.add(message.messageId!);
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     _processedMessages.clear();
  //   });
  // }

  // Future<String?> getToken() async {
  //   String? token = await _fcm.getToken();
  //   _logger.d('Token: $token');
  //   return token;
  // }

  // Future<void> subscribeToTopic(String topic) async {
  //   await _fcm.subscribeToTopic(topic);
  //   _logger.d('Subscribed to topic: $topic');
  // }

  // Future<void> unsubscribeFromTopic(String topic) async {
  //   await _fcm.unsubscribeFromTopic(topic);
  //   _logger.d('Unsubscribed from topic: $topic');
  // }

  // Stream<RemoteMessage> get messageStream => _messageStreamController.stream
  //     .distinct((prev, next) => prev.messageId == next.messageId);

  // void dispose() {
  //   _messageStreamController.close();
  // }

  // void backgroundOpenApp() async {
  //   _fcm.getInitialMessage().then((message) {
  //     if (message != null && !_processedMessages.contains(message.messageId)) {
  //       _handleMessage(message);
  //       if (message.notification != null) {
  //         _messageStreamController.sink.add(message);
  //       }
  //       _processedMessages.add(message.messageId!);
  //     }
  //   });
  // }

  // static Future<void> backgroundHandler(RemoteMessage message) async {
  //   Logger().d('Handling a background message ${message.messageId}');
  //   if (message.data.isNotEmpty) {
  //     Logger().d('Message also contained data: ${message.data}');
  //   }
  //   if (message.notification != null) {
  //     Logger().d(
  //         'Message also contained a notification: ${message.notification?.title}');
  //     _messageStreamController.sink.add(message);
  //   }
  // }
}
