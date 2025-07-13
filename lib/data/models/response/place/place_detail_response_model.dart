class PlaceDetailResponse {
  final int id;
  final String name;
  final String description;
  final String address;
  final int categoryId;
  final String kabupaten;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;
  final String photoUrl;
  final double averageRating;
  final int reviewCount;
  final List<Review> reviews;

  PlaceDetailResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.categoryId,
    required this.kabupaten,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
    required this.photoUrl,
    required this.averageRating,
    required this.reviewCount,
    required this.reviews,
  });

  factory PlaceDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailResponse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      categoryId: json['category_id'],
      kabupaten: json['kabupaten'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      photoUrl: json['photo_url'],
      averageRating: double.tryParse(json['average_rating'].toString()) ?? 0.0,
      reviewCount: json['review_count'],
      reviews: (json['reviews'] as List)
          .map((r) => Review.fromJson(r))
          .toList(),
    );
  }
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;
  final String photoUrl;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.photoUrl,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['user_name'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      comment: json['comment'],
      createdAt: json['created_at'],
      photoUrl: json['photo_url'],
    );
  }
}
