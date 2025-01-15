import 'package:flutter_base_template/core/base_repository.dart';
import 'package:flutter_base_template/models/user_model.dart';
import 'package:flutter_base_template/repository/user/user_repository.dart';
import 'package:sqflite/sqflite.dart';

class LocalUserRepository extends BaseRepository implements UserRepository {
  static const String _tableName = 'users';

  LocalUserRepository({
    super.databaseService,
    super.logger,
  });

  @override
  Future<UserModel?> getUser(int id) async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final List<Map<String, dynamic>> results = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return UserModel.fromDb(results.first);
    });
  }

  @override
  Future<List<UserModel>> getUsers() async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final List<Map<String, dynamic>> results = await db.query(_tableName);
      return results.map((data) => UserModel.fromDb(data)).toList();
    });
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await handleDatabaseOperation(() async {
      final db = await databaseService.database;
      await db.insert(
        _tableName,
        user.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<void> deleteUser(int id) async {
    await handleDatabaseOperation(() async {
      final db = await databaseService.database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  @override
  Future<void> syncUsers() async {
    throw UnimplementedError('Sync is not supported in local repository');
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final List<Map<String, dynamic>> results = await db.query(
        _tableName,
        where: 'name LIKE ? OR email LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return results.map((data) => UserModel.fromDb(data)).toList();
    });
  }

  Future<void> saveUsers(List<UserModel> users) async {
    await handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final batch = db.batch();
      for (var user in users) {
        batch.insert(
          _tableName,
          user.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<int> getUserCount() async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final results =
          await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
      return Sqflite.firstIntValue(results) ?? 0;
    });
  }
}
