import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:kitakesana/data/models/request/review/post_review_request_model.dart';
import 'package:kitakesana/data/models/response/review/review_response_model.dart';
import 'package:kitakesana/data/models/response/review/review_latest_response_model.dart';

class ReviewService {
  final _storage = FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3000/api';

  // ✅ POST review
  Future<void> postReview(PostReviewRequestModel request) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/reviews');

    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(request.toFields());

    if (request.photo != null) {
      final mime =
          lookupMimeType(request.photo!.path)?.split('/') ?? ['image', 'jpeg'];
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          request.photo!.path,
          contentType: MediaType(mime[0], mime[1]),
        ),
      );
    }

    final ioClient = IOClient(HttpClient());
    final streamedResponse = await ioClient.send(multipartRequest);

    if (streamedResponse.statusCode != 200) {
      final body = await streamedResponse.stream.bytesToString();
      final jsonBody = json.decode(body);
      throw Exception(jsonBody['error'] ?? 'Gagal mengirim ulasan');
    }
  }

  // ✅ GET reviews by place
  Future<List<ReviewResponseModel>> fetchReviewsByPlace(int placeId) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/reviews?place_id=$placeId');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((r) => ReviewResponseModel.fromJson(r)).toList();
    } else {
      throw Exception('Gagal mengambil ulasan: ${response.body}');
    }
  }

  // ✅ PUT review
  Future<void> updateReview(int id, PostReviewRequestModel request) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/reviews/$id');

    final multipartRequest = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(request.toFields());

    if (request.photo != null) {
      final mime =
          lookupMimeType(request.photo!.path)?.split('/') ?? ['image', 'jpeg'];
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          request.photo!.path,
          contentType: MediaType(mime[0], mime[1]),
        ),
      );
    }

    final ioClient = IOClient(HttpClient());
    final streamedResponse = await ioClient.send(multipartRequest);

    if (streamedResponse.statusCode != 200) {
      final body = await streamedResponse.stream.bytesToString();
      final jsonBody = json.decode(body);
      throw Exception(jsonBody['error'] ?? 'Gagal memperbarui ulasan');
    }
  }

  // ✅ DELETE review
  Future<void> deleteReview(int id) async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/reviews/$id');

    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      final jsonBody = json.decode(response.body);
      throw Exception(jsonBody['error'] ?? 'Gagal menghapus ulasan');
    }
  }

  Future<List<ReviewLatestResponseModel>> getAllReviews() async {
    final token = await _storage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl/reviews/all');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ReviewLatestResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat review terbaru: ${response.body}');
    }
  }
}
