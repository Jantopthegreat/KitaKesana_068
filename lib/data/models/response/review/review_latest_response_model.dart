class ReviewLatestResponseModel {
  final int id;
  final int userId;
  final String userName;
  final int placeId;
  final String placeName;
  final double rating;
  final String comment;
  final String createdAt;
  final String photoUrl;

  ReviewLatestResponseModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.placeId,
    required this.placeName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.photoUrl,
  });

  factory ReviewLatestResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewLatestResponseModel(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      placeId: json['place_id'],
      placeName: json['place_name'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: json['created_at'],
      photoUrl: 'http://10.0.2.2:3000${json['photo_url']}',
    );
  }
}
