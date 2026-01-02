import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/hive/hive_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../state/auth_state.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel();
});

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(AuthState.initial()) {
    checkCurrentUser();
  }

  final HiveService _hiveService = HiveService();

  /// Load user from Hive on app start
  Future<void> checkCurrentUser() async {
    final user = _hiveService.getCurrentUser();
    if (user != null) {
      state = state.copyWith(currentUser: user, isAuthenticated: true);
    }
  }

  /// Login (mock - replace with real API later)
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validation
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(isLoading: false, error: 'Please fill all fields');
      return;
    }

    if (!email.contains('@')) {
      state = state.copyWith(isLoading: false, error: 'Invalid email');
      return;
    }

    // Extract username safely (after validation we know '@' exists)
    final username = email.split('@').first;

    // Create mock user
    final user = AuthEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: email,
    );

    // Save to Hive
    await _hiveService.saveUser(user);

    // Update state
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      currentUser: user,
      error: null,
    );
  }

  /// Register (mock - replace with real API later)
  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(seconds: 1));

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      state = state.copyWith(isLoading: false, error: 'Please fill all fields');
      return;
    }

    final user = AuthEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: email,
    );

    await _hiveService.saveUser(user);

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      currentUser: user,
      error: null,
    );
  }

  /// Logout
  Future<void> logout() async {
    await _hiveService.logout();
    state = state.copyWith(isAuthenticated: false, currentUser: null);
  }
}
