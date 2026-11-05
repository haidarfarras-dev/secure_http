import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service dari praktikum, digunakan lagi untuk login dan logout (Latihan 1-2).
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const String _tokenKey = 'auth_token';
  static const String _pinKey = 'user_pin';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    debugPrint('Token berhasil disimpan'); // Tidak mencetak nilai token
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    debugPrint(token == null ? 'Token tidak ditemukan' : 'Token ditemukan');
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    debugPrint('Token berhasil dihapus');
  }

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    debugPrint('PIN berhasil disimpan');
  }

  Future<String?> getPin() => _storage.read(key: _pinKey);

  Future<void> deleteAll() async {
    await _storage.deleteAll();
    debugPrint('Semua data berhasil dihapus');
  }

  Future<bool> hasToken() => _storage.containsKey(key: _tokenKey);
}
