import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/entities/auth_entities.dart';

class SecureStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kIdentity = 'identity';

  final FlutterSecureStorage _storage;

  const SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  /// Save identity string (phone:deviceId)
  Future<void> saveIdentity(String identity) async {
    await _storage.write(key: _kIdentity, value: identity);
  }

  /// Retrieve access token
  Future<String?> get accessToken async => _storage.read(key: _kAccess);

  /// Retrieve refresh token
  Future<String?> get refreshToken async => _storage.read(key: _kRefresh);

  /// Retrieve identity
  Future<String?> get identity async => _storage.read(key: _kIdentity);

  /// Get both tokens as entity
  Future<AuthTokens?> getTokens() async {
    final access = await _storage.read(key: _kAccess);
    final refresh = await _storage.read(key: _kRefresh);
    if (access == null ||
        access.isEmpty ||
        refresh == null ||
        refresh.isEmpty) {
      return null;
    }
    return AuthTokens(access: access, refresh: refresh);
  }

  /// Clear only tokens
  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }

  /// Clear everything
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
