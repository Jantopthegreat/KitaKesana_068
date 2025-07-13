class ReviewResponseModel {
  final int id;
  final int userId; // Assuming you have a user ID field
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;
  final String photoUrl;

  ReviewResponseModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.photoUrl,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      comment: json['comment'],
      createdAt: json['created_at'],
      photoUrl: json['photo_url'],
    );
  }
}
