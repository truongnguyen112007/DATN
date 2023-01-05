// To parse this JSON data, do
//
//     final RoutesModel = RoutesModelFromJson(jsonString);

import 'dart:convert';

import 'package:base_bloc/data/model/user_profile_model.dart';


List<RoutesModel> routeModelBySearchFromJson(List<dynamic> str) =>
    List<RoutesModel>.from(
        str.map((x) => RoutesModel.fromJson(x['_source']['after'])));

List<RoutesModel> routeModelFromJson(List<dynamic> str) =>
    List<RoutesModel>.from(str.map((x) => RoutesModel.fromJson(x)));

String routeModelToJson(List<RoutesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoutesModel {
  RoutesModel({
    // this.modified,
    this.userGrade,
    this.hasConner,
    this.name,
    this.popurlarity,
    this.userId,
    this.published,
    this.userGradeCount,
    this.visibility,
    this.height,
    this.id,
    this.authorGrade,
    this.created,
    this.holds,
    this.isSelect = false,
    this.playlistIn,
    this.favouriteIn,
    this.userProfile,
    this.authorFirstName,
    this.authorLastName
  });

  // int? modified;
  int? userGrade;
  bool? hasConner;
  String? name;
  String? authorFirstName;
  String? authorLastName;
  int? popurlarity;
  int? userId;
  bool? published;
  int? userGradeCount;
  int? visibility;
  int? height;
  String? id;
  int? authorGrade;
  int? created;
  String? holds;
  bool isSelect;
  bool? playlistIn;
  bool? favouriteIn;
  UserProfileModel? userProfile;

  factory RoutesModel.fromJson(Map<String, dynamic> json) => RoutesModel(
    // modified: json["modified"],
    userGrade: json["user_grade"].toInt(),
    hasConner: json["has_conner"],
    name: json["name"],
    popurlarity: json["popurlarity"],
    userId: json["user_id"],
    published: json["published"],
    userGradeCount: json["user_grade_count"].toInt(),
    visibility: json["visibility"],
    height: json["height"],
    id: json["id"],
    authorGrade: json["author_grade"].toInt(),
    created: json["created"],
    holds: json["holds"].toString(),
    isSelect: false,
    playlistIn: json["playlist_in"],
    authorLastName: json["author_last_name"],
    authorFirstName: json["author_first_name"],
    favouriteIn: json["favourite_in"],
    userProfile: json["user_profile"] != null
          ? UserProfileModel.fromJson(json["user_profile"])
          : null);

  Map<String, dynamic> toJson() => {
    // "modified": modified,
    "user_grade": userGrade,
    "has_conner": hasConner,
    "name": name,
    "popurlarity": popurlarity,
    "user_id": userId,
    "published": published,
    "user_grade_count": userGradeCount,
    "visibility": visibility,
    "height": height,
    "id": id,
    "author_grade": authorGrade,
    "created": created,
    "holds": holds,
    "playlist_in" : playlistIn,
    "favourite_in" : favouriteIn,
  };
}

