import 'package:flutter_base_template/core/base_repository.dart';
import 'package:flutter_base_template/models/user_model.dart';
import 'package:flutter_base_template/repository/user/user_repository.dart';
import 'package:flutter_base_template/repository/user/local/local_user_repository.dart';
import 'package:flutter_base_template/utils/networking/url_provider.dart';

class RemoteUserRepository extends BaseRepository implements UserRepository {
  final LocalUserRepository _localRepository;

  RemoteUserRepository({
    super.apiClient,
    super.databaseService,
    LocalUserRepository? localRepository,
    super.logger,
  }) : _localRepository = localRepository ?? LocalUserRepository();

  @override
  Future<UserModel?> getUser(int id) async {
    return handleCacheOperation(
      () => _localRepository.getUser(id),
      () async {
        final response = await handleApiCall(
          () => apiClient.get(URLProvider()
              .addPathSegments(URLProvider().userEndpoint, [id.toString()])),
        );

        if (response.data == null) return null;

        final user = UserModel.fromJson(response.data);
        await _localRepository.saveUser(user);
        return user;
      },
    );
  }

  @override
  Future<List<UserModel>?> getUsers() async {
    return handleCacheOperation(
      () => _localRepository.getUsers(),
      () async {
        final response = await handleApiCall(
          () => apiClient.get(URLProvider().userEndpoint),
        );

        final List<dynamic> data = response.data as List<dynamic>;
        final users = data.map((json) => UserModel.fromJson(json)).toList();

        await _localRepository.saveUsers(users);
        return users;
      },
    );
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await handleApiCall(() async {
      await apiClient.post(
        URLProvider().userEndpoint,
        data: user.toJson(),
      );

      await handleDatabaseOperation(
        () => _localRepository.saveUser(user),
      );
    });
  }

  @override
  Future<void> deleteUser(int id) async {
    await handleApiCall(() async {
      await apiClient.delete(
        URLProvider()
            .addPathSegments(URLProvider().userEndpoint, [id.toString()]),
      );

      await handleDatabaseOperation(
        () => _localRepository.deleteUser(id),
      );
    });
  }

  @override
  Future<void> syncUsers() async {
    await handleSyncOperation(
      () async {
        final lastSyncedUser = await _getLastSyncedUser();
        final lastSyncTime = lastSyncedUser?.lastSync;

        final response = await handleApiCall(
          () => apiClient.get(
            URLProvider().userEndpoint,
            queryParameters: lastSyncTime != null
                ? {'since': lastSyncTime.toIso8601String()}
                : null,
          ),
        );

        final List<dynamic> data = response.data as List<dynamic>;
        final users = data.map((json) => UserModel.fromJson(json)).toList();

        await handleDatabaseOperation(
          () => _localRepository.saveUsers(users),
        );
      },
      onConflict: () async {
        // Handle sync conflicts here
        logger.w('Handling sync conflict');

        // For example, fetch all data and overwrite local
        final response = await handleApiCall(
          () => apiClient.get(URLProvider().userEndpoint),
        );
        final List<dynamic> data = response.data as List<dynamic>;
        final users = data.map((json) => UserModel.fromJson(json)).toList();
        await handleDatabaseOperation(
          () => _localRepository.saveUsers(users),
        );
      },
      onComplete: () {
        logger.i('Sync completed successfully');
        return Future.value();
      },
    );
  }

  @override
  Future<List<UserModel>?> searchUsers(String query) async {
    return handleCacheOperation(
      () => _localRepository.searchUsers(query),
      () async {
        final response = await handleApiCall(
          () => apiClient.get(
            URLProvider()
                .addPathSegments(URLProvider().userEndpoint, ['search']),
            queryParameters: {'q': query},
          ),
        );

        final List<dynamic> data = response.data as List<dynamic>;
        final users = data.map((json) => UserModel.fromJson(json)).toList();

        await handleDatabaseOperation(
          () => _localRepository.saveUsers(users),
        );
        return users;
      },
    );
  }

  Future<UserModel?> _getLastSyncedUser() async {
    return handleDatabaseOperation(() async {
      final users = await _localRepository.getUsers();
      if (users.isEmpty) return null;

      return users.reduce((curr, next) {
        final currSync = curr.lastSync;
        final nextSync = next.lastSync;
        if (currSync == null) return next;
        if (nextSync == null) return curr;
        return currSync.isAfter(nextSync) ? curr : next;
      });
    });
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    await _localRepository.dispose();
  }
}
