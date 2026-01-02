import '../../domain/entities/auth_entity.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final AuthEntity? currentUser;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.currentUser,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      currentUser: null,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    AuthEntity? currentUser,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      error: error ?? this.error,
    );
  }
}
