import 'package:kitakesana/data/models/response/place/place_response_model.dart';
import 'package:kitakesana/data/repositories/place_repository.dart';
import 'package:kitakesana/data/models/response/place/place_response_model.dart';
import 'package:kitakesana/data/models/response/place/place_detail_response_model.dart';
import 'package:kitakesana/data/models/response/admin/place/place_admin_response_model.dart';
import 'package:kitakesana/data/models/request/admin/place/post_place_admin_request_model.dart';
import 'package:kitakesana/data/models/response/admin/place/place_admin_response_model.dart';
import 'package:kitakesana/services/service_http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PlaceService {
  final PlaceRepository _repository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3000/api';

  PlaceService(this._repository);

  Future<List<PlaceResponseModel>> fetchRecommendedPlaces({
    String? kabupaten,
    String? category,
  }) async {
    return await _repository.getRecommendedPlaces(
      kabupaten: kabupaten,
      category: category,
    );
  }

  Future<PlaceDetailResponse> fetchPlaceDetail(int id) async {
    return await _repository.getPlaceDetail(id);
  }

  // ✅ GET all places (for admin)
  Future<List<PlaceAdminResponseModel>> getAllPlaces() async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/places/all');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PlaceAdminResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat tempat: ${response.body}');
    }
  }
}
