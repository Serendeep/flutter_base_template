import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const int _databaseVersion = 1;
  static const String _databaseName = "app.db";

  // Initialization and opening of database
  Future<Database> initDB() async {
    String path = await getDatabasesPath() + _databaseName;
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    //Example
    // await db.execute(_createUserTableSQL);
  }

  //Implement versioning onUpgrade to handle seamless database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    //Example
    // if (oldVersion < 2) {
    //   // This block will run for upgrading to version 2 from version 1
    //   await db.execute('ALTER TABLE user ADD COLUMN new_column TEXT;');
    // }
    // if (oldVersion < 3 && newVersion >= 3) {
    //   // This block will run for upgrading to version 3 (and checks that newVersion is 3 or higher)
    //   await db.execute('CREATE TABLE new_table (...);');
    // }
    // // Add more if blocks as necessary for further versions
  }

  Future<void> dropTable(Database database, String tableName) async {
    await database.execute('DROP TABLE IF EXISTS $tableName;');
  }
}
