import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/hive/hive_service.dart';
import '../../data/models/auth_hive_model.dart';
import '../../domain/entities/auth_entity.dart';
import '../state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});

class AuthViewModel extends Notifier<AuthState> {
  final HiveService _hiveService = HiveService();

  @override
  AuthState build() {
    return AuthState.initial();
  }

  Future<void> checkCurrentUser() async {
    final user = _hiveService.getCurrentUser();
    if (user != null) {
      state = state.copyWith(
        isAuthenticated: true,
        currentUser: AuthEntity(
          id: user.id,
          username: user.username,
          email: user.email,
        ),
        error: null, // Clear any errors
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = _hiveService.getAllUsers();

      final matchedUser = users.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
        orElse: () =>
            AuthHiveModel(id: '', username: '', email: '', passwordHash: ''),
      );

      if (matchedUser.id.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'No account found with this email',
        );
        return;
      }

      final inputHash = sha256.convert(utf8.encode(password)).toString();

      if (inputHash != matchedUser.passwordHash) {
        state = state.copyWith(isLoading: false, error: 'Incorrect password');
        return;
      }

      await _hiveService.saveCurrentUser(matchedUser);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        error: null, // ✅ Clear error on successful login
        currentUser: AuthEntity(
          id: matchedUser.id,
          username: matchedUser.username,
          email: matchedUser.email,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed. Please try again.',
      );
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = _hiveService.getAllUsers();
      final exists = users.any(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      );

      if (exists) {
        state = state.copyWith(
          isLoading: false,
          error: 'Email already registered',
        );
        return;
      }

      final passwordHash = sha256.convert(utf8.encode(password)).toString();

      final newUser = AuthHiveModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username.trim(),
        email: email.trim(),
        passwordHash: passwordHash,
      );

      await _hiveService.saveUser(newUser);
      await _hiveService.saveCurrentUser(newUser);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        error: null, // ✅ Clear error on successful registration
        currentUser: AuthEntity(
          id: newUser.id,
          username: newUser.username,
          email: newUser.email,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Registration failed');
    }
  }

  Future<void> logout() async {
    await _hiveService.logout();
    state = state.copyWith(
      isAuthenticated: false,
      currentUser: null,
      error: null, // ✅ Clear error on logout
    );
  }
}
