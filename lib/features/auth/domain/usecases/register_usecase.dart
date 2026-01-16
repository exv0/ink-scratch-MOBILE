// lib/features/auth/domain/usecases/register_usecase.dart
import '../repositories/auth_repository.dart';
import '../entities/auth_entity.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  Future<AuthEntity> call({
    required String fullName,
    String? phoneNumber, // ✅ Made nullable
    required String gender,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) {
    return authRepository.register(
      fullName: fullName,
      phoneNumber: phoneNumber ?? '', // ✅ Provide empty string if null
      gender: gender,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
