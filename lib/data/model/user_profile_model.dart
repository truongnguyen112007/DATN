// To parse this JSON data, do
//
//     final UserProfileModel = UserProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.id,
    this.accountId,
    this.username,
    this.email,
    this.emailAccount,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.photo,
    this.phone,
    this.role,
    this.profileType,
    this.description,
    this.modified,
    this.created,
    this.height
  });

  int? id;
  int? accountId;
  dynamic? username;
  String? email;
  String? emailAccount;
  String? firstName;
  String? lastName;
  String? gender;
  int? birthDate;
  String? photo;
  String? phone;
  String? role;
  String? profileType;
  dynamic? description;
  DateTime? modified;
  DateTime? created;
  dynamic? height;


  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json["id"],
        accountId: json["account_id"],
        username: json["username"],
        email: json["email"],
        emailAccount: json["email_account"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        birthDate: json["birth_date"],
        photo: json["photo"],
        phone: json["phone"],
        role: json["role"],
        profileType: json["profile_type"],
        description: json["description"],
          modified: json["modified"] != null
              ? DateTime.parse(json["modified"])
              : DateTime.now(),
          created: json["created"] != null
              ? DateTime.parse(json["created"])
              : DateTime.now(),
          height: json["height"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_id": accountId,
        "username": username,
        "email": email,
        "email_account": emailAccount,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "birth_date": birthDate,
        "photo": photo,
        "phone": phone,
        "role": role,
        "profile_type": profileType,
        "description": description,
        "modified": modified?.toIso8601String(),
        "created": created?.toIso8601String(),
        "height" : height
      };
}

