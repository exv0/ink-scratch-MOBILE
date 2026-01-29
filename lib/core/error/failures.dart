// lib/core/error/failures.dart
abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message); // ✅ Using super parameter
}

class CacheFailure extends Failure {
  const CacheFailure(super.message); // ✅ Using super parameter
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message); // ✅ Using super parameter
}
