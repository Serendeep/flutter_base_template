import 'package:klackr_mobile/services/db/database_service.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _database;
  final DatabaseService _appDB = DatabaseService();

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _appDB.initDB();
    return _database!;
  }
}
