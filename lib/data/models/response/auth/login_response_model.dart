import 'dart:convert';

class LoginResponseModel {
  final String? token;
  final User? user;

  LoginResponseModel({this.token, this.user});

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        token: json["token"],
        user: json["user"] != null ? User.fromMap(json["user"]) : null,
      );

  Map<String, dynamic> toMap() => {"token": token, "user": user?.toMap()};
}

class User {
  final int? id;
  final String? name;
  final String? role;

  User({this.id, this.name, this.role});

  factory User.fromMap(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"], role: json["role"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name, "role": role};
}
