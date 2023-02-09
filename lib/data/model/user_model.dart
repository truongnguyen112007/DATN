// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.token,
    required this.user,
  });

  String token;
  User user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.phone,
    this.rememberMeToken,
    required this.roleId,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String phone;
  dynamic rememberMeToken;
  int roleId;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    rememberMeToken: json["remember_me_token"],
    roleId: json["role_id"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "remember_me_token": rememberMeToken,
    "role_id": roleId,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
