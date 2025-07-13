import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kitakesana/data/models/response/admin/place/place_admin_response_model.dart';
import 'package:kitakesana/data/models/request/admin/place/post_place_admin_request_model.dart';
import 'package:kitakesana/data/repositories/admin/admin_place_repository.dart';
import 'package:http/http.dart' as http;

class AdminPlaceService {
  final AdminPlaceRepository _repository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3000/api';

  AdminPlaceService(this._repository);

  Future<List<PlaceAdminResponseModel>> fetchAllPlaces() async {
    return await _repository.getAllPlacesAdmin();
  }

  Future<void> createPlace(PostPlaceAdminRequestModel request) async {
    return await _repository.createPlace(request);
  }

  Future<void> updatePlace(int id, PostPlaceAdminRequestModel request) async {
    return await _repository.updatePlace(id, request);
  }

  Future<void> deletePlace(int id) async {
    return await _repository.deletePlace(id);
  }
}
