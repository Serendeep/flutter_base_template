import 'package:flutter_base_template/services/db/database_service.dart';
import 'package:flutter_base_template/utils/networking/api_client.dart';
import 'package:logger/logger.dart';

abstract class BaseRepository {
  final ApiClient _apiClient;
  final DatabaseService _databaseService;
  final Logger _logger;

  BaseRepository({
    ApiClient? apiClient,
    DatabaseService? databaseService,
    Logger? logger,
  })  : _apiClient = apiClient ?? ApiClient(),
        _databaseService = databaseService ?? DatabaseService.instance,
        _logger = logger ?? Logger();

  ApiClient get apiClient => _apiClient;
  DatabaseService get databaseService => _databaseService;
  Logger get logger => _logger;

  /// Handle API errors with custom logic
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (error, stackTrace) {
      _logger.e(
        'API Error in ${runtimeType.toString()}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Handle database operations with error handling and retries
  Future<T> handleDatabaseOperation<T>(
    Future<T> Function() dbOperation, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(milliseconds: 200),
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await dbOperation();
      } catch (error, stackTrace) {
        attempts++;
        _logger.w(
          'Database operation failed in ${runtimeType.toString()}, attempt $attempts of $maxRetries',
          error: error,
          stackTrace: stackTrace,
        );
        if (attempts == maxRetries) {
          _logger.e(
            'Database operation failed after $maxRetries attempts',
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
        await Future.delayed(retryDelay * attempts);
      }
    }
    throw Exception('Database operation failed after $maxRetries attempts');
  }

  /// Handle cache operations with error handling
  Future<T?> handleCacheOperation<T>(
    Future<T?> Function() cacheOperation,
    Future<T?> Function() fallbackOperation,
  ) async {
    try {
      final result = await cacheOperation();
      if (result != null) return result;
      return await fallbackOperation();
    } catch (error, stackTrace) {
      _logger.w(
        'Cache operation failed in ${runtimeType.toString()}, falling back',
        error: error,
        stackTrace: stackTrace,
      );
      try {
        return await fallbackOperation();
      } catch (fallbackError, fallbackStackTrace) {
        _logger.e(
          'Fallback operation failed in ${runtimeType.toString()}',
          error: fallbackError,
          stackTrace: fallbackStackTrace,
        );
        rethrow;
      }
    }
  }

  /// Handle sync operations with proper error handling and conflict resolution
  Future<void> handleSyncOperation(
    Future<void> Function() syncOperation, {
    Future<void> Function()? onConflict,
    Future<void> Function()? onComplete,
  }) async {
    try {
      await syncOperation();
      if (onComplete != null) await onComplete();
    } catch (error, stackTrace) {
      if (error is ConflictException && onConflict != null) {
        _logger.w(
          'Sync conflict detected in ${runtimeType.toString()}, attempting resolution',
          error: error,
          stackTrace: stackTrace,
        );
        try {
          await onConflict();
        } catch (conflictError, conflictStackTrace) {
          _logger.e(
            'Conflict resolution failed in ${runtimeType.toString()}',
            error: conflictError,
            stackTrace: conflictStackTrace,
          );
          rethrow;
        }
      } else {
        _logger.e(
          'Sync operation failed in ${runtimeType.toString()}',
          error: error,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    }
  }

  /// Dispose of any resources
  Future<void> dispose() async {
    try {
      await _databaseService.close();
    } catch (error, stackTrace) {
      _logger.e(
        'Error disposing repository resources',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

class ConflictException implements Exception {
  final String message;
  final dynamic conflictData;

  ConflictException(this.message, {this.conflictData});

  @override
  String toString() => 'ConflictException: $message';
}
