import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/core/api/api_client.dart';
import 'package:ink_scratch/core/services/storage/user_session_service.dart';
import 'package:ink_scratch/features/auth/data/datasources/remote/auth_remote_datasource.dart';

/// ----------------------------
/// UserSessionService Provider
/// ----------------------------
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService();
});

/// ----------------------------
/// ApiClient Provider
/// ----------------------------
final apiClientProvider = Provider<ApiClient>((ref) {
  final sessionService = ref.read(userSessionServiceProvider);
  return ApiClient(
    baseUrl: 'http://YOUR_BACKEND_URL', // <-- replace with your backend URL
    sessionService: sessionService,
  );
});

/// ----------------------------
/// AuthRemoteDatasource Provider
/// ----------------------------
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final sessionService = ref.read(userSessionServiceProvider);
  return AuthRemoteDatasource(
    apiClient: apiClient,
    sessionService: sessionService,
  );
});
