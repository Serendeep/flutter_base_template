import 'package:flutter_base_template/core/base_repository.dart';
import 'package:flutter_base_template/models/user_model.dart';

abstract class UserRepository extends BaseRepository {
  Future<UserModel?> getUser(int id);
  Future<List<UserModel>?> getUsers();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser(int id);
  Future<void> syncUsers();
  Future<List<UserModel>?> searchUsers(String query);
}
