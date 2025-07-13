import 'package:kitakesana/data/models/request/auth/login_request_model.dart';
import 'package:kitakesana/data/models/response/auth/login_response_model.dart';
import 'package:kitakesana/data/models/request/auth/register_request_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:kitakesana/services/service_http.dart';
import 'dart:convert';

class AuthRepository {
  final _http = HttpServices();
  final _storage = FlutterSecureStorage(); // ✅

  Future<LoginResponseModel?> login(LoginRequestModel model) async {
    final response = await _http.post('/auth/login', model.toMap());

    if (response.statusCode == 200) {
      final loginResponse = LoginResponseModel.fromJson(response.body);

      if (loginResponse.token != null) {
        await _storage.write(key: 'authToken', value: loginResponse.token!);
        await _storage.write(
          key: 'user_id',
          value: loginResponse.user?.id.toString(),
        );
        await _storage.write(
          key: 'name',
          value: loginResponse.user?.name ?? '',
        );
        await _storage.write(
          key: 'role',
          value: loginResponse.user?.role ?? '',
        );
      }

      return loginResponse;
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  Future<String> register(RegisterRequestModel model) async {
    final response = await _http.post('/auth/register', model.toMap());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['message'] ?? 'Registrasi berhasil';
    } else {
      throw Exception('Register gagal: ${response.body}');
    }
  }
}
