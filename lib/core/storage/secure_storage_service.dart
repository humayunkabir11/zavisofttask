import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._internal();

  static final SecureStorageService _instance =
  SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  /// Secure by default (Android Keystore + iOS Keychain)
  final FlutterSecureStorage _storage =
  const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // ================== WRITE ==================
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // ================== READ ==================
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // ================== DELETE ==================
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // ================== UTIL ==================
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
