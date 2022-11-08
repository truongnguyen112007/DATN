// To parse this JSON data, do
//
//     final PlaylistModel = PlaylistModelFromJson(jsonString);

import 'dart:convert';

List<PlaylistModel> playListModelFromJson(List<dynamic> str) =>
    List<PlaylistModel>.from(str.map((x) => PlaylistModel.fromJson(x)));

String playListModelToJson(List<PlaylistModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaylistModel {
  PlaylistModel({
    this.created,
    this.userId,
    this.modified,
    this.name,
    this.id,
  });

  int? created;
  int? userId;
  int? modified;
  String? name;
  String? id;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
    created: json["created"],
    userId: json["user_id"],
    modified: json["modified"],
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "created": created,
    "user_id": userId,
    "modified": modified,
    "name": name,
    "id": id,
  };
}
