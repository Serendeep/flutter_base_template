import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_base_template/utils/config/app_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_base_template/utils/config/bloc_dispatcher.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_base_template/core/error/app_error.dart';

class PushNotificationService {
  static PushNotificationService? _instance;
  final Logger _logger = Logger();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> _tokenSubject = BehaviorSubject<String?>();
  final BehaviorSubject<RemoteMessage> _messageSubject =
      BehaviorSubject<RemoteMessage>();
  final BlocDispatcher _blocDispatcher;
  bool _isInitialized = false;

  // Streams
  Stream<String?> get tokenStream => _tokenSubject.stream;
  Stream<RemoteMessage> get messageStream => _messageSubject.stream;

  // Constructor
  PushNotificationService._({required BlocDispatcher blocDispatcher})
      : _blocDispatcher = blocDispatcher {
    if (!AppConfig.enablePushNotifications) {
      _logger.i('Push notifications are disabled in this environment');
      return;
    }
  }

  static PushNotificationService initialize(
      {required BlocDispatcher blocDispatcher}) {
    _instance ??= PushNotificationService._(blocDispatcher: blocDispatcher);
    return _instance!;
  }

  static PushNotificationService get instance {
    if (_instance == null) {
      throw StateError('PushNotificationService must be initialized first');
    }
    return _instance!;
  }

  Future<void> init() async {
    if (!AppConfig.enablePushNotifications) {
      _logger.i('Push notifications are disabled. Skipping initialization.');
      return;
    }

    if (_isInitialized) {
      _logger.i('Push notification service already initialized');
      return;
    }

    try {
      // Initialize Firebase
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
        _logger.i('Firebase initialized successfully');
      }

      // Request permission and initialize
      await Future.wait([
        _requestPermission(),
        _initializeLocalNotifications(),
      ]);

      // Configure FCM
      await _configureFCM();

      // Get initial token
      await _updateToken();

      _isInitialized = true;
      _logger.i('Push Notification Service initialized successfully');
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to initialize Push Notification Service',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
      rethrow;
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      _logger
          .i('Notification permission status: ${settings.authorizationStatus}');
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to request notification permission',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
      rethrow;
    }
  }

  Future<void> _initializeLocalNotifications() async {
    try {
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      );

      _logger.i('Local notifications initialized successfully');
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to initialize local notifications',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
      rethrow;
    }
  }

  Future<void> _configureFCM() async {
    try {
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check for initial message
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      _logger.i('FCM configured successfully');
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to configure FCM',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
      rethrow;
    }
  }

  Future<void> _updateToken() async {
    try {
      final token = await _fcm.getToken();
      _tokenSubject.add(token);
      _logger.i('FCM Token updated successfully');

      // Listen for token refresh
      _fcm.onTokenRefresh.listen(
        (token) {
          _tokenSubject.add(token);
          _logger.i('FCM Token refreshed');
        },
        onError: (e, stackTrace) {
          AppError.create(
            message: 'Error refreshing FCM token',
            type: ErrorType.unknown,
            stackTrace: stackTrace,
            originalError: e,
          );
        },
      );
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to get FCM token',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
      rethrow;
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      _logger.i('Received foreground message: ${message.messageId}');
      _messageSubject.add(message);

      await _showLocalNotification(message);
      _blocDispatcher.handleNotification(message.data);
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Error handling foreground message',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null) {
        await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Default Channel',
              channelDescription: 'Default notification channel',
              importance: Importance.max,
              priority: Priority.high,
              icon: android?.smallIcon,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data.toString(),
        );
        _logger.i('Local notification shown successfully');
      }
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to show local notification',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    try {
      _logger.i('Notification tapped: ${message.messageId}');
      _messageSubject.add(message);
      // Add your navigation logic here
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Error handling notification tap',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
    }
  }

  void _onLocalNotificationTapped(NotificationResponse response) {
    try {
      _logger.i('Local notification tapped: ${response.payload}');
      // Add your local notification tap handling logic here
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Error handling local notification tap',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    if (!_isInitialized) {
      _logger.e('Cannot subscribe to topic: Service not initialized');
      return;
    }

    try {
      await _fcm.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to subscribe to topic: $topic',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
      rethrow;
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isInitialized) {
      _logger.e('Cannot unsubscribe from topic: Service not initialized');
      return;
    }

    try {
      await _fcm.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Failed to unsubscribe from topic: $topic',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
      rethrow;
    }
  }

  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      await Future.wait([
        _tokenSubject.close(),
        _messageSubject.close(),
      ]);
      _instance = null;
      _isInitialized = false;
      _logger.i('Push notification service disposed successfully');
    } catch (e, stackTrace) {
      AppError.create(
        message: 'Error disposing push notification service',
        type: ErrorType.unknown,
        stackTrace: stackTrace,
        originalError: e,
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final logger = Logger();
  try {
    // Initialize Firebase for background handler
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      logger.i('Firebase initialized successfully');
    }

    logger.i('Handling background message: ${message.messageId}');
    // Add your background message handling logic here
  } catch (e, stackTrace) {
    AppError.create(
      message: 'Error in background message handler',
      type: ErrorType.unknown,
      stackTrace: stackTrace,
      originalError: e,
    );
  }
}
