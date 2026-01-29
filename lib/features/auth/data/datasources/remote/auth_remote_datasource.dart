import 'package:dio/dio.dart';
import 'package:ink_scratch/core/services/storage/user_session_service.dart';
import 'package:ink_scratch/core/error/exception.dart';
import 'package:ink_scratch/core/api/api_client.dart';
import 'package:ink_scratch/features/auth/domain/entities/auth_entity.dart';
import 'package:logger/logger.dart'; // Import the logger package

class AuthRemoteDatasource {
  final ApiClient apiClient;
  final UserSessionService sessionService;
  final Logger logger = Logger(); // Create an instance of Logger

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
      // Use logger for logging instead of print
      logger.d('REGISTER REQUEST:');
      logger.d('   URL: ${apiClient.client.options.baseUrl}/register');
      logger.d(
        '   Data: { fullName: $fullName, phoneNumber: $phoneNumber, gender: $gender, email: $email, username: $username }',
      );

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

      logger.d(
        'REGISTER RESPONSE: Status: ${response.statusCode}, Data: ${response.data}',
      );

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final token = response.data['token'] as String?;

        if (token != null) {
          await sessionService.saveToken(token);
          logger.d('Token saved: ${token.substring(0, 20)}...');
        }

        return AuthEntity.fromMap(userData, token: token);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      // Log the error using the logger
      logger.e(
        'REGISTER ERROR: Type: ${e.type}, Message: ${e.message}, Response: ${e.response?.data}, Status: ${e.response?.statusCode}',
      );
      final message =
          e.response?.data['message'] ?? e.message ?? 'Registration failed';
      throw ServerException(message);
    } catch (e) {
      logger.e('UNEXPECTED ERROR: $e');
      throw ServerException(e.toString());
    }
  }

  /// Login user
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      logger.d(
        'LOGIN REQUEST: URL: ${apiClient.client.options.baseUrl}/login, Email: $email',
      );

      final response = await apiClient.client.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      logger.d(
        'LOGIN RESPONSE: Status: ${response.statusCode}, Data: ${response.data}',
      );

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final token = response.data['token'] as String;

        // Save token locally
        await sessionService.saveToken(token);
        logger.d('Token saved: ${token.substring(0, 20)}...');

        return AuthEntity.fromMap(userData, token: token);
      } else {
        throw ServerException(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      logger.e(
        'LOGIN ERROR: Type: ${e.type}, Message: ${e.message}, Response: ${e.response?.data}, Status: ${e.response?.statusCode}',
      );
      final message =
          e.response?.data['message'] ?? e.message ?? 'Login failed';
      throw ServerException(message);
    } catch (e) {
      logger.e('UNEXPECTED ERROR: $e');
      throw ServerException(e.toString());
    }
  }

  /// Logout user
  Future<void> logout() async {
    logger.d('LOGOUT: Clearing token...');
    await sessionService.clearToken();
    logger.d('Token cleared');
  }

  /// Update user profile (bio and profile picture)
  Future<AuthEntity> updateProfile({
    String? bio,
    String? profilePicturePath,
  }) async {
    try {
      logger.d('UPDATE PROFILE REQUEST:');
      logger.d('   URL: ${apiClient.client.options.baseUrl}/update-profile');
      logger.d('   Bio: $bio, ProfilePicture: $profilePicturePath');

      FormData formData = FormData();

      // Add bio if provided
      if (bio != null && bio.isNotEmpty) {
        formData.fields.add(MapEntry('bio', bio));
      }

      // Add profile image if provided
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await MultipartFile.fromFile(
              profilePicturePath,
              filename: profilePicturePath.split('/').last,
            ),
          ),
        );
      }

      final response = await apiClient.client.put(
        '/update-profile',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      logger.d(
        'UPDATE PROFILE RESPONSE: Status: ${response.statusCode}, Data: ${response.data}',
      );

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final token = await sessionService.getToken();

        return AuthEntity.fromMap(userData, token: token);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Profile update failed',
        );
      }
    } on DioException catch (e) {
      logger.e(
        'UPDATE PROFILE ERROR: Type: ${e.type}, Message: ${e.message}, Response: ${e.response?.data}, Status: ${e.response?.statusCode}',
      );
      final message =
          e.response?.data['message'] ?? e.message ?? 'Profile update failed';
      throw ServerException(message);
    } catch (e) {
      logger.e('UNEXPECTED ERROR: $e');
      throw ServerException(e.toString());
    }
  }
}
