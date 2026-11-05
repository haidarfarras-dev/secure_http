import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/post.dart';

/// Perluasan ApiService dari praktikum: /users, /posts, dan timeout dinamis.
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _defaultTimeout = Duration(seconds: 10);

  Future<dynamic> _getJson(String endpoint, Duration timeout) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$endpoint'))
          .timeout(timeout);

      // Logging aman: hanya endpoint dan status, tanpa token/password.
      debugPrint('GET $endpoint - HTTP ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ApiRequestException(
          'Gagal memuat data. Status HTTP: ${response.statusCode}',
        );
      }
      return jsonDecode(response.body);
    } on TimeoutException {
      throw ApiRequestException(
        'Request timeout. Batas waktu permintaan telah terlampaui.',
      );
    } on http.ClientException {
      throw ApiRequestException(
        'Gagal terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on FormatException {
      throw ApiRequestException('Format respons JSON tidak valid.');
    } on ApiRequestException {
      rethrow;
    } catch (_) {
      throw ApiRequestException('Terjadi kesalahan saat mengambil data.');
    }
  }

  // Latihan 5: timeout dapat dipilih oleh pemanggil; default 10 detik.
  Future<List<User>> getUsers({
    Duration timeout = _defaultTimeout,
  }) async {
    final data = await _getJson('/users', timeout);
    if (data is! List) {
      throw ApiRequestException('Format daftar pengguna tidak valid.');
    }
    try {
      return data
          .map((item) => User.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      throw ApiRequestException('Data pengguna tidak dapat diproses.');
    }
  }

  Future<User> getUserById(int id, {
    Duration timeout = _defaultTimeout,
  }) async {
    final data = await _getJson('/users/$id', timeout);
    if (data is! Map) {
      throw ApiRequestException('Format detail pengguna tidak valid.');
    }
    try {
      return User.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {
      throw ApiRequestException('Detail pengguna tidak dapat diproses.');
    }
  }

  // Latihan 3: GET /posts.
  Future<List<Post>> getPosts({
    Duration timeout = _defaultTimeout,
  }) async {
    final data = await _getJson('/posts', timeout);
    if (data is! List) {
      throw ApiRequestException('Format daftar postingan tidak valid.');
    }
    try {
      return data
          .map((item) => Post.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      throw ApiRequestException('Data postingan tidak dapat diproses.');
    }
  }

  // Latihan 1: login simulasi dari modul (bukan autentikasi sungguhan).
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.trim().isEmpty || password.isEmpty) {
      throw ApiRequestException('Email dan password tidak boleh kosong.');
    }
    // Token dummy; jangan log token, email, atau password.
    debugPrint('Simulasi login berhasil');
    return 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class ApiRequestException implements Exception {
  final String message;
  const ApiRequestException(this.message);

  @override
  String toString() => message;
}
