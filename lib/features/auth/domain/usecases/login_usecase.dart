// lib/features/auth/domain/usecases/login_usecase.dart
import '../repositories/auth_repository.dart'; // ✅ Fixed import
import '../entities/auth_entity.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<AuthEntity> call({required String email, required String password}) {
    return authRepository.login(email: email, password: password);
  }
}
