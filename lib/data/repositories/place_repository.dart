import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:kitakesana/data/models/request/admin/place/post_place_admin_request_model.dart';
import 'package:kitakesana/data/models/response/place/place_response_model.dart';
import 'package:kitakesana/data/models/response/place/place_detail_response_model.dart';
import 'package:kitakesana/services/service_http.dart';

class PlaceRepository {
  final HttpServices _http = HttpServices();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<PlaceResponseModel>> getRecommendedPlaces({
    String? kabupaten,
    String? category,
  }) async {
    try {
      final params = <String, String>{};
      if (kabupaten != null) params['kabupaten'] = kabupaten;
      if (category != null) params['category'] = category;

      final query = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final url = query.isNotEmpty ? '/places?$query' : '/places';

      final response = await _http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((item) => PlaceResponseModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Gagal memuat data tempat wisata');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<PlaceDetailResponse> getPlaceDetail(int id) async {
    try {
      final response = await _http.get('/places/$id');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PlaceDetailResponse.fromJson(jsonData);
      } else {
        throw Exception('Gagal memuat detail tempat wisata');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat ambil detail: $e');
    }
  }

  // ✅ GET semua tempat (admin)
  Future<List<PlaceResponseModel>> getAllPlaces() async {
    final response = await _http.get('/places/all');
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => PlaceResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat semua tempat wisata');
    }
  }
}
