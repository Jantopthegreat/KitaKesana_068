import 'dart:io';

class PostEventRequestModel {
  final String name;
  final String description;
  final String kabupaten;
  final String category;
  final double latitude;
  final double longitude;
  final String startTime; // Format: 'YYYY-MM-DD HH:mm:ss'
  final File? photo;

  PostEventRequestModel({
    required this.name,
    required this.description,
    required this.kabupaten,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.startTime,
    this.photo,
  });

  Map<String, String> toFields() {
    return {
      'name': name,
      'description': description,
      'kabupaten': kabupaten,
      'category': category,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'start_time': startTime,
    };
  }

  factory PostEventRequestModel.fromMap(Map<String, dynamic> map) {
    return PostEventRequestModel(
      name: map['name'],
      description: map['description'],
      kabupaten: map['kabupaten'],
      category: map['category'],
      latitude: double.parse(map['latitude'].toString()),
      longitude: double.parse(map['longitude'].toString()),
      startTime: map['start_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'kabupaten': kabupaten,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'start_time': startTime,
    };
  }

  factory PostEventRequestModel.fromJson(Map<String, dynamic> json) {
    return PostEventRequestModel.fromMap(json);
  }

  Map<String, dynamic> toJson() => toMap();
}
