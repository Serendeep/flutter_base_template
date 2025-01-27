import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_base_template/services/db/database_service.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  final DatabaseService _appDB = DatabaseService.instance;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Box> get database async {
    await _appDB.initHive(); // Ensure Hive is initialized
    return _appDB.userBox;
  }
}
