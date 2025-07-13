import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:kitakesana/data/models/response/admin/place/place_admin_response_model.dart';
import 'package:kitakesana/data/models/request/admin/place/post_place_admin_request_model.dart';

class AdminPlaceRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3000/api';

  // ✅ GET semua tempat wisata (Admin)
  Future<List<PlaceAdminResponseModel>> getAllPlacesAdmin() async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/places/all/admin');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => PlaceAdminResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat tempat wisata');
    }
  }

  // ✅ POST - Tambah tempat baru
  Future<void> createPlace(PostPlaceAdminRequestModel model) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/places');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(model.toFields());

    if (model.photo != null) {
      final mime =
          lookupMimeType(model.photo!.path)?.split('/') ?? ['image', 'jpeg'];
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          model.photo!.path,
          contentType: MediaType(mime[0], mime[1]),
        ),
      );
    }

    final ioClient = IOClient(HttpClient());
    final response = await ioClient.send(request);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      final jsonBody = json.decode(body);
      throw Exception(jsonBody['error'] ?? 'Gagal menambahkan tempat');
    }
  }

  // ✅ PUT - Update tempat
  Future<void> updatePlace(int id, PostPlaceAdminRequestModel model) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/places/$id');

    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(model.toFields());

    if (model.photo != null) {
      final mime =
          lookupMimeType(model.photo!.path)?.split('/') ?? ['image', 'jpeg'];
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          model.photo!.path,
          contentType: MediaType(mime[0], mime[1]),
        ),
      );
    }

    final ioClient = IOClient(HttpClient());
    final response = await ioClient.send(request);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      final jsonBody = json.decode(body);
      throw Exception(jsonBody['error'] ?? 'Gagal memperbarui tempat');
    }
  }

  // ✅ DELETE - Hapus tempat
  Future<void> deletePlace(int id) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/places/$id');

    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final jsonBody = json.decode(response.body);
      throw Exception(jsonBody['error'] ?? 'Gagal menghapus tempat');
    }
  }
}
