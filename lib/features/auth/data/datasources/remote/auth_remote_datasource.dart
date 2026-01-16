import 'package:dio/dio.dart';
import 'package:ink_scratch/core/services/storage/user_session_service.dart';
import 'package:ink_scratch/core/error/exception.dart';
import 'package:ink_scratch/core/api/api_client.dart';
import 'package:ink_scratch/features/auth/domain/entities/auth_entity.dart';

class AuthRemoteDatasource {
  final ApiClient apiClient;
  final UserSessionService sessionService;

  AuthRemoteDatasource({required this.apiClient, required this.sessionService});

  /// Register user
  Future<AuthEntity> register({
    required String fullName,
    required String phoneNumber,
    required String gender,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // 🔍 DEBUG: Log the request
      print('🚀 REGISTER REQUEST:');
      print('   URL: ${apiClient.client.options.baseUrl}/register');
      print('   Data: {');
      print('     fullName: $fullName,');
      print('     phoneNumber: $phoneNumber,');
      print('     gender: $gender,');
      print('     email: $email,');
      print('     username: $username,');
      print('   }');

      final response = await apiClient.client.post(
        '/register',
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'gender': gender,
          'email': email,
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      // 🔍 DEBUG: Log the response
      print('✅ REGISTER RESPONSE:');
      print('   Status: ${response.statusCode}');
      print('   Data: ${response.data}');

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final token =
            response.data['token'] as String?; // ✅ Get token from response

        // ✅ Save token if present
        if (token != null) {
          await sessionService.saveToken(token);
          print('✅ Token saved: ${token.substring(0, 20)}...');
        }

        return AuthEntity.fromMap(userData, token: token);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      // 🔍 DEBUG: Log the error
      print('❌ REGISTER ERROR:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Response: ${e.response?.data}');
      print('   Status: ${e.response?.statusCode}');

      final message =
          e.response?.data['message'] ?? e.message ?? 'Registration failed';
      throw ServerException(message);
    } catch (e) {
      print('❌ UNEXPECTED ERROR: $e');
      throw ServerException(e.toString());
    }
  }

  /// Login user
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      // 🔍 DEBUG: Log the request
      print('🚀 LOGIN REQUEST:');
      print('   URL: ${apiClient.client.options.baseUrl}/login');
      print('   Email: $email');

      final response = await apiClient.client.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      // 🔍 DEBUG: Log the response
      print('✅ LOGIN RESPONSE:');
      print('   Status: ${response.statusCode}');
      print('   Data: ${response.data}');

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final token = response.data['token'] as String;

        // Save token locally
        await sessionService.saveToken(token);
        print('✅ Token saved: ${token.substring(0, 20)}...');

        return AuthEntity.fromMap(userData, token: token);
      } else {
        throw ServerException(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      // 🔍 DEBUG: Log the error
      print('❌ LOGIN ERROR:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Response: ${e.response?.data}');
      print('   Status: ${e.response?.statusCode}');

      final message =
          e.response?.data['message'] ?? e.message ?? 'Login failed';
      throw ServerException(message);
    } catch (e) {
      print('❌ UNEXPECTED ERROR: $e');
      throw ServerException(e.toString());
    }
  }

  /// Logout user
  Future<void> logout() async {
    print('🚪 LOGOUT: Clearing token...');
    await sessionService.clearToken();
    print('✅ Token cleared');
  }
}
