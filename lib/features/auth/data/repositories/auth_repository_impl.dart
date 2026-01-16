// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:ink_scratch/core/error/exception.dart';
import 'package:ink_scratch/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ink_scratch/features/auth/domain/entities/auth_entity.dart';
import 'package:ink_scratch/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<AuthEntity> register({
    required String fullName,
    String? phoneNumber, // ✅ Changed to nullable
    required String gender,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final auth = await remoteDatasource.register(
        fullName: fullName,
        phoneNumber: phoneNumber ?? '', // ✅ Provide empty string if null
        gender: gender,
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );
      return auth;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final auth = await remoteDatasource.login(
        email: email,
        password: password,
      );
      return auth;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDatasource.logout();
    } on ServerException {
      rethrow;
    }
  }
}
