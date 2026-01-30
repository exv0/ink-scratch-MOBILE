// lib/core/config/app_config.dart
class AppConfig {
  // IMPORTANT: Choose the right URL based on where you're testing:

  // For Android Emulator:
  // static const String baseUrl = 'http://10.0.2.2:3000/api/auth';

  // For iOS Simulator or Web (running Flutter on same machine as backend):
  // static const String baseUrl = 'http://localhost:3000/api/auth';

  // For Physical Device (replace with your computer's IP):
  // Find your IP: Run 'ipconfig' on Windows, look for IPv4 Address

  static const String baseUrl = 'http://192.168.1.70:3000/api/auth';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
