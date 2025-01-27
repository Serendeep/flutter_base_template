import 'package:flutter_base_template/core/base_repository.dart';
import 'package:flutter_base_template/core/error/app_error.dart';
import 'package:flutter_base_template/models/user_model.dart';
import 'package:flutter_base_template/repository/user/user_repository.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class LocalUserRepository extends BaseRepository implements UserRepository {
  static const String _userBoxName = 'users';

  LocalUserRepository({
    super.databaseService,
    super.logger,
  });

  @override
  Future<UserModel?> getUser(int id) async {
    return handleDatabaseOperation(() async {
      final box = await Hive.openBox(_userBoxName);
      final userMap = box.get(id.toString());
      return userMap != null ? UserModel.fromDb(userMap) : null;
    });
  }

  @override
  Future<List<UserModel>> getUsers() async {
    return handleDatabaseOperation(() async {
      final box = await Hive.openBox(_userBoxName);
      return box.values.map((data) => UserModel.fromDb(data)).toList();
    });
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await handleDatabaseOperation(() async {
      final box = await Hive.openBox(_userBoxName);
      await box.put(user.id.toString(), user.toDb());
    });
  }

  @override
  Future<void> deleteUser(int id) async {
    await handleDatabaseOperation(() async {
      final box = await Hive.openBox(_userBoxName);
      await box.delete(id.toString());
    });
  }

  @override
  Future<void> syncUsers() async {
    AppError.create(
      message: 'Sync is not supported in local repository',
      type: ErrorType.database,
      shouldLog: true,
    );
    throw UnimplementedError('Sync is not supported in local repository');
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    return handleDatabaseOperation(() async {
      final box = await Hive.openBox(_userBoxName);
      return box.values
          .map((data) => UserModel.fromDb(data))
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> saveUsers(List<UserModel> users) async {
    await handleDatabaseOperation(() async {
      final box = await Hive.openBox(_userBoxName);
      for (var user in users) {
        await box.put(user.id.toString(), user.toDb());
      }
    });
  }

  Future<int> getUserCount() async {
    return handleDatabaseOperation(() async {
      final box = await Hive.openBox(_userBoxName);
      return box.length;
    });
  }
}
