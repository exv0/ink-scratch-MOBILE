// lib/features/auth/presentation/view_model/auth_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:ink_scratch/core/services/storage/user_session_service.dart';
import 'package:ink_scratch/features/auth/domain/usecases/login_usecase.dart';
import 'package:ink_scratch/features/auth/domain/usecases/register_usecase.dart';
import 'package:ink_scratch/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ink_scratch/features/auth/presentation/state/auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final UserSessionService _sessionService = UserSessionService();
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       super(AuthState.initial());

  Future<void> checkCurrentUser() async {
    final token = await _sessionService.getToken();
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authEntity = await _loginUseCase.call(
        email: email.trim(),
        password: password,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: authEntity,
        error: null,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.error.toString());
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String fullName,
    String? phoneNumber, // ✅ Made nullable
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    String? gender,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authEntity = await _registerUseCase.call(
        fullName: fullName.trim(),
        phoneNumber:
            phoneNumber?.trim() ??
            '', // ✅ Handle null, send empty string if null
        gender: gender ?? 'Not Specified',
        email: email.trim(),
        username: username.trim(),
        password: password,
        confirmPassword: confirmPassword,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: authEntity,
        error: null,
      );
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.error.toString());
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _logoutUseCase.call();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        currentUser: null,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
