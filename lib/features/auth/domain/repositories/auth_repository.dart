// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> register({
    required String fullName,
    String? phoneNumber, // ✅ Made nullable
    required String gender,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  });

  Future<AuthEntity> login({required String email, required String password});

  Future<void> logout();
}
