import 'dart:async';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_base_template/core/error/app_error.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Box? _userBox;
  final Logger _logger = Logger();

  // Hive box names
  static const _userBoxName = 'users';

  // Private constructor
  DatabaseService._();

  // Singleton instance
  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  // Initialize Hive
  Future<void> initHive() async {
    try {
      await Hive.initFlutter();

      // Open user box
      _userBox = await Hive.openBox(_userBoxName);

      _logger.i('Hive initialized successfully');
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to initialize Hive database',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // User box getter
  Box get userBox {
    if (_userBox == null) {
      throw AppError.create(
        message: 'Hive not initialized. Call initHive() first.',
        type: ErrorType.database,
      );
    }
    return _userBox!;
  }

  // Generic methods for Hive operations
  Future<void> saveUser(String key, Map<String, dynamic> userData) async {
    try {
      await userBox.put(key, userData);
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to save user data',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<Map<String, dynamic>?> getUser(String key) async {
    try {
      return userBox.get(key) as Map<String, dynamic>?;
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to retrieve user data',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteUser(String key) async {
    try {
      await userBox.delete(key);
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to delete user data',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Close Hive boxes
  Future<void> close() async {
    try {
      await _userBox?.close();
      await Hive.close();
      _userBox = null;
      _instance = null;
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to close Hive database',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
