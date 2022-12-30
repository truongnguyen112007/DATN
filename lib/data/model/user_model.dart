// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.userId,
    this.role,
    this.refreshToken,
    this.token,
  });

  int? userId;
  String? role;
  String? refreshToken;
  String? token;

  UserModel copyOf(
          {int? userId, String? role, String? refreshToken, String? token}) =>
      UserModel(
          userId: userId ?? this.userId,
          role: role ?? this.role,
          refreshToken: refreshToken ?? this.refreshToken,
          token: token ?? this.token);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
    role: json["role"],
    refreshToken: json["refresh_token"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "role": role,
    "refresh_token": refreshToken,
    "token": token,
  };
}
