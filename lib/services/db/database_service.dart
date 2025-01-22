import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';
import 'package:flutter_base_template/core/error/app_error.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;
  final Logger _logger = Logger();

  // Database version and name
  static const _databaseName = "app_database.db";
  static const _databaseVersion = 1;

  // Private constructor
  DatabaseService._();

  // Singleton instance
  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  // Database instance getter
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), _databaseName);
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: onDatabaseDowngradeDelete,
      );
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to initialize database',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.transaction((txn) async {
        // Users table
        await txn.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            avatar TEXT,
            last_sync TEXT
          )
        ''');

        // Create indexes
        await txn.execute('CREATE INDEX idx_users_email ON users(email)');

        _logger.i('Database tables created successfully');
      });
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to create database tables',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      await db.transaction((txn) async {
        if (oldVersion < 2) {
          // Add new tables or columns for version 2
        }
      });
      _logger.i('Database upgraded from $oldVersion to $newVersion');
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to upgrade database from $oldVersion to $newVersion',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Generic query methods with automatic retry
  Future<T> _withRetry<T>(Future<T> Function() operation,
      {int maxRetries = 3}) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e, stackTrace) {
        attempts++;
        if (attempts == maxRetries) {
          throw AppError.create(
            message: 'Database operation failed after $maxRetries attempts',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
        await Future.delayed(Duration(milliseconds: 200 * attempts));
        AppError.create(
          message: 'Retrying database operation, attempt $attempts',
          type: ErrorType.database,
          originalError: e,
          stackTrace: stackTrace,
          shouldLog: false, // Suppress logging for retry attempts
        );
      }
    }
    throw AppError.create(
      message: 'Unexpected error in database retry mechanism',
      type: ErrorType.database,
    );
  }

  // Batch operations
  Future<void> runBatch(void Function(Batch batch) operations) async {
    final db = await database;
    await _withRetry(() async {
      final batch = db.batch();
      operations(batch);
      await batch.commit(noResult: true);
    });
  }

  // Transaction wrapper
  Future<T> runTransaction<T>(
      Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await _withRetry(() => db.transaction(action));
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
