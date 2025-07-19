import 'package:flutter/foundation.dart';

class AppConfig {
  // Network configuration
  static String get baseUrl {
    if (kIsWeb) {
      // For web platform
      return 'http://localhost:5500';
    } else {
      // For mobile platforms (Android/iOS)
      // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
      return 'http://localhost:5500';
    }
  }

  // Simple configuration - uncomment and use this if you want to hardcode for your platform
  // static String get baseUrl => 'http://localhost:5500'; // For web
  // static String get baseUrl => 'http://10.0.2.2:5500'; // For Android emulator

  static String get apiBaseUrl => '$baseUrl/api/messages';
  static String get socketUrl => baseUrl;

  // You can also use your actual IP address if testing on physical device
  // Replace with your computer's IP address when testing on physical device
  static String get physicalDeviceUrl => 'http://localhost:5500';
}
