import 'package:hive/hive.dart';
import '../../domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart'; // Run flutter pub run build_runner build after

@HiveType(typeId: 1) // Match your hive_table_constant if needed
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? token;

  AuthHiveModel({
    required this.id,
    required this.username,
    required this.email,
    this.token,
  });

  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      token: entity.token,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(id: id, username: username, email: email, token: token);
  }
}
