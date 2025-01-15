import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime? lastSync;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.lastSync,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      lastSync: json['last_sync'] != null 
        ? DateTime.parse(json['last_sync'] as String)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'last_sync': lastSync?.toIso8601String(),
    };
  }

  factory UserModel.fromDb(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] as int,
      name: data['name'] as String,
      email: data['email'] as String,
      avatar: data['avatar'] as String?,
      lastSync: data['last_sync'] != null 
        ? DateTime.parse(data['last_sync'] as String)
        : null,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? lastSync,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatar, lastSync];
}
