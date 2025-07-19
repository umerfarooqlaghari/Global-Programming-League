import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _authTokenKey = 'authToken';

  /// Write a token to secure storage
  Future<void> writeToken(String token) async {
    print('Storing Token: $token'); // Debug log
    await _storage.write(key: _authTokenKey, value: token);
  }

  /// Read the token from secure storage
  Future<String?> readToken() async {
    final token = await _storage.read(key: _authTokenKey);
    print('Read Token: $token'); // Debug log
    return token;
  }

  /// Delete the token from secure storage
  Future<void> deleteToken() async {
    print('Deleting Token'); // Debug log
    await _storage.delete(key: _authTokenKey);
  }
}
