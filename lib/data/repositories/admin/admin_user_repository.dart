import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:kitakesana/data/models/response/admin/users/user_admin_response_model.dart';

class AdminUserRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3000/api';

  // ✅ GET semua user (untuk admin)
  Future<List<UserAdminResponseModel>> getAllUsers() async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/users');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => UserAdminResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pengguna');
    }
  }

  // ✅ DELETE user
  Future<void> deleteUser(int id) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/users/$id');

    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final jsonBody = json.decode(response.body);
      throw Exception(jsonBody['error'] ?? 'Gagal menghapus pengguna');
    }
  }
}
