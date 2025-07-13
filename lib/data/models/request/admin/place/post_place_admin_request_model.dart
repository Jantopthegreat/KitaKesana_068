import 'dart:io';

class PostPlaceAdminRequestModel {
  final String name;
  final String description;
  final String address;
  final String kabupaten;
  final int categoryId;
  final double latitude;
  final double longitude;
  final File? photo;

  PostPlaceAdminRequestModel({
    required this.name,
    required this.description,
    required this.address,
    required this.kabupaten,
    required this.categoryId,
    required this.latitude,
    required this.longitude,
    this.photo,
  });

  // Digunakan untuk MultipartRequest
  Map<String, String> toFields() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'kabupaten': kabupaten,
      'category_id': categoryId.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
  }

  // Jika butuh fromJson/toJson (opsional, untuk edit)
  factory PostPlaceAdminRequestModel.fromJson(Map<String, dynamic> json) {
    return PostPlaceAdminRequestModel(
      name: json['name'],
      description: json['description'],
      address: json['address'],
      kabupaten: json['kabupaten'],
      categoryId: json['category_id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      photo: null, // karena dari JSON tidak bisa ambil file
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'kabupaten': kabupaten,
      'category_id': categoryId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
