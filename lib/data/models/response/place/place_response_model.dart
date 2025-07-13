class PlaceResponseModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final int categoryId;
  final String kabupaten;
  final double latitude;
  final double longitude;
  final String photoUrl;
  final double rating;

  PlaceResponseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.categoryId,
    required this.kabupaten,
    required this.latitude,
    required this.longitude,
    required this.photoUrl,
    required this.rating,
  });

  factory PlaceResponseModel.fromJson(Map<String, dynamic> json) {
    return PlaceResponseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      categoryId: json['category_id'] ?? 0,
      kabupaten: json['kabupaten'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      photoUrl: json['photo_url'] ?? '',
      rating:
          double.tryParse(
            json['average_rating']?.toString() ??
                json['rating']?.toString() ??
                '0',
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'category_id': categoryId,
      'kabupaten': kabupaten,
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photoUrl,
      'rating': rating,
    };
  }
}
