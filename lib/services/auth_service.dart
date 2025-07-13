import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kitakesana/data/models/request/auth/login_request_model.dart';
import 'package:kitakesana/data/models/response/auth/login_response_model.dart';
import 'package:kitakesana/services/service_http.dart';

class AuthService {
  final _http = HttpServices();
  final _storage = FlutterSecureStorage();

  Future<LoginResponseModel> login(LoginRequestModel model) async {
    final response = await _http.post('/auth/login', model.toMap());

    if (response.statusCode == 200) {
      final loginResult = LoginResponseModel.fromJson(response.body);

      if (loginResult.token != null) {
        await _storage.write(key: 'authToken', value: loginResult.token!);
        await _storage.write(key: 'name', value: loginResult.user?.name ?? '');
        await _storage.write(key: 'role', value: loginResult.user?.role ?? '');
        await _storage.write(
          key: 'user_id',
          value: loginResult.user?.id.toString(),
        );

        print('[DEBUG] Token Saved: ${loginResult.token}');
        return loginResult;
      } else {
        throw Exception('Token tidak ditemukan dalam response');
      }
    }

    throw Exception('Gagal login: ${response.body}');
  }

  Future<void> logout() async {
    await _storage.deleteAll(); // bersihkan semua token dan user data
  }
}
