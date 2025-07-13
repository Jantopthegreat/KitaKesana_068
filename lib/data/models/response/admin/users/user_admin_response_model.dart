class UserAdminResponseModel {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;
  final int totalReviews;

  UserAdminResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.totalReviews,
  });

  factory UserAdminResponseModel.fromJson(Map<String, dynamic> json) {
    return UserAdminResponseModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      totalReviews: json['total_reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'total_reviews': totalReviews,
    };
  }
}
