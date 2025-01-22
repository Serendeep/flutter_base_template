import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_base_template/utils/config/app_config.dart';

class AppError {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;
  final ErrorType type;

  AppError({
    required this.message,
    this.originalError,
    this.stackTrace,
    this.type = ErrorType.unknown,
  });

  void log() {
    if (AppConfig.shouldShowLogs) {
      final logger = Logger();
      switch (type) {
        case ErrorType.network:
          logger.e('Network Error: $message',
              error: originalError, stackTrace: stackTrace);
          break;
        case ErrorType.authentication:
          logger.e('Authentication Error: $message',
              error: originalError, stackTrace: stackTrace);
          break;
        case ErrorType.validation:
          logger.w('Validation Error: $message',
              error: originalError, stackTrace: stackTrace);
          break;
        case ErrorType.unknown:
        default:
          logger.e('Unknown Error: $message',
              error: originalError, stackTrace: stackTrace);
      }

      // Optional: Add crash reporting here (e.g., Firebase Crashlytics)
      if (kDebugMode) {
        debugPrint('Error: $message');
      }
    }
  }

  factory AppError.fromException(dynamic exception) {
    if (exception is NetworkException) {
      return AppError(
        message: exception.message,
        type: ErrorType.network,
        stackTrace: exception.stackTrace,
      );
    }

    return AppError(
      message: exception.toString(),
      type: ErrorType.unknown,
    );
  }

  factory AppError.fromDioError(DioException dioException) {
    String message;
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error: ${dioException.response?.statusCode}';
        break;
      case DioExceptionType.unknown:
        message = 'Unknown error: ${dioException.response?.statusMessage}';
        break;
      default:
        message = 'Unknown error: ${dioException.response?.statusMessage}';
    }

    return AppError(
      message: message,
      type: ErrorType.network,
      stackTrace: dioException.stackTrace,
    );
  }

  static AppError create({
    required String message,
    ErrorType type = ErrorType.unknown,
    Object? originalError,
    StackTrace? stackTrace,
    bool shouldLog = true,
  }) {
    final error = AppError(
      message: message,
      type: type,
      originalError: originalError,
      stackTrace: stackTrace,
    );

    if (shouldLog) {
      error.log();
    }

    return error;
  }
}

enum ErrorType {
  network,
  authentication,
  validation,
  unknown,
  database,
  configuration,
}

class NetworkException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  NetworkException(this.message, {this.stackTrace});
}
