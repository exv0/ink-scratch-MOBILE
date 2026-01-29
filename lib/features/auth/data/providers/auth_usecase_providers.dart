// lib/features/auth/data/providers/auth_usecase_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/features/auth/domain/usecases/login_usecase.dart';
import 'package:ink_scratch/features/auth/domain/usecases/register_usecase.dart';
import 'package:ink_scratch/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ink_scratch/features/auth/domain/usecases/update_profile_usecase.dart'; // ✅ Add this
import 'package:ink_scratch/features/auth/data/providers/auth_repository_provider.dart';

/// Provides the LoginUseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUseCase(authRepository: repo);
});

/// Provides the RegisterUseCase
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return RegisterUseCase(authRepository: repo);
});

/// Provides the LogoutUseCase
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LogoutUseCase(authRepository: repo);
});

// ✅ Add this provider
/// Provides the UpdateProfileUseCase
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return UpdateProfileUseCase(repository: repo);
});
