class PlaceAdminResponseModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String kabupaten;
  final String category;
  final double latitude;
  final double longitude;
  final double rating;
  final String photoUrl;

  PlaceAdminResponseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.kabupaten,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.photoUrl,
  });

  factory PlaceAdminResponseModel.fromJson(Map<String, dynamic> json) {
    return PlaceAdminResponseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      kabupaten: json['kabupaten'],
      category: json['category'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      photoUrl: json['photo_url'],
    );
  }
}
