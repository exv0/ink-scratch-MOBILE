import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/core/api/api_client.dart';
import 'package:ink_scratch/core/services/storage/user_session_service.dart';
import 'package:ink_scratch/core/config/app_config.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final sessionService = UserSessionService();
  return ApiClient(baseUrl: AppConfig.baseUrl, sessionService: sessionService);
});
