import 'package:hive/hive.dart';

class UserSessionService {
  static const String _boxName = 'user_session';
  static const String _tokenKey = 'auth_token';

  /// Save token
  Future<void> saveToken(String token) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_tokenKey, token);
    await box.close();
  }

  /// Get token
  Future<String?> getToken() async {
    final box = await Hive.openBox(_boxName);
    final token = box.get(_tokenKey) as String?;
    await box.close();
    return token;
  }

  /// Clear token (logout)
  Future<void> clearToken() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_tokenKey);
    await box.close();
  }
}
