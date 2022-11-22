// To parse this JSON data, do
//
//     final RoutesModel = RoutesModelFromJson(jsonString);

import 'dart:convert';


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
    // this.userId,
    this.published,
    this.userGradeCount,
    // this.visibility,
    this.height,
    this.id,
    this.authorGrade,
    this.created,
    this.holds,
    this.isSelect = false,
    this.playlistIn,
    this.favouriteIn,
  });

  // int? modified;
  int? userGrade;
  bool? hasConner;
  String? name;
  int? popurlarity;
  // int? userId;
  bool? published;
  int? userGradeCount;
  // int? visibility;
  int? height;
  String? id;
  int? authorGrade;
  int? created;
  String? holds;
  bool isSelect;
  bool? playlistIn;
  bool? favouriteIn;


  factory RoutesModel.fromJson(Map<String, dynamic> json) => RoutesModel(
    // modified: json["modified"],
    userGrade: json["user_grade"],
    hasConner: json["has_conner"],
    name: json["name"],
    popurlarity: json["popurlarity"],
    // userId: json["user_id"],
    published: json["published"],
    userGradeCount: json["user_grade_count"],
    // visibility: json["visibility"],
    height: json["height"],
    id: json["id"],
    authorGrade: json["author_grade"],
    created: json["created"],
    holds: json["holds"],
    isSelect: false,
    playlistIn: json["playlist_in"],
    favouriteIn: json["favourite_in"]
  );

  Map<String, dynamic> toJson() => {
    // "modified": modified,
    "user_grade": userGrade,
    "has_conner": hasConner,
    "name": name,
    "popurlarity": popurlarity,
    // "user_id": userId,
    "published": published,
    "user_grade_count": userGradeCount,
    // "visibility": visibility,
    "height": height,
    "id": id,
    "author_grade": authorGrade,
    "created": created,
    "holds": holds,
    "playlist_in" : playlistIn,
    "favourite_in" : favouriteIn,
  };
}

