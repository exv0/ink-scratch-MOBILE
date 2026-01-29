// lib/features/auth/domain/usecases/update_profile_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<Either<Failure, AuthEntity>> call({
    String? bio,
    String? profilePicturePath,
  }) async {
    return await repository.updateProfile(
      bio: bio,
      profilePicturePath: profilePicturePath,
    );
  }
}
