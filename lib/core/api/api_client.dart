import 'package:dio/dio.dart';
import '../services/storage/user_session_service.dart';

class ApiClient {
  final Dio _dio;
  final UserSessionService _sessionService;

  ApiClient({
    required String baseUrl,
    required UserSessionService sessionService,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           headers: {'Content-Type': 'application/json'},
         ),
       ),
       _sessionService = sessionService {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _sessionService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response != null) {
            final data = error.response?.data;
            String message = 'Unknown error';
            if (data != null && data is Map<String, dynamic>) {
              message = data['message'] ?? message;
            }
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                error: message,
              ),
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get client => _dio;
}
