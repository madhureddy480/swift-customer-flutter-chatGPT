import 'package:dr_swift_diagnostics/core/constants/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  const SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();
}

class TokenStorage {
  const TokenStorage(this._secureStorage);

  final SecureStorageService _secureStorage;

  Future<String?> readAccessToken() =>
      _secureStorage.read(StorageKeys.accessToken);

  Future<String?> readRefreshToken() =>
      _secureStorage.read(StorageKeys.refreshToken);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(StorageKeys.accessToken, accessToken);
    await _secureStorage.write(StorageKeys.refreshToken, refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
  }

  Future<bool> hasValidSession() async {
    final token = await readAccessToken();
    return token != null && token.isNotEmpty;
  }
}
