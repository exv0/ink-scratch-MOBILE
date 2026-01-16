import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../services/storage/user_session_service.dart';

final userSessionProvider = Provider<UserSessionService>((ref) {
  return UserSessionService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final session = ref.read(userSessionProvider);
  return ApiClient(
    baseUrl: 'http://10.0.2.2:3000', // Android emulator
    sessionService: session,
  );
});
