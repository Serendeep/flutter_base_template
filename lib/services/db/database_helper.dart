import 'package:flutter_base_template/services/db/database_service.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _database;
  final DatabaseService _appDB = DatabaseService.instance;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _appDB.database;
    return _database!;
  }
}
