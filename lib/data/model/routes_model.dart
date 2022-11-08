// To parse this JSON data, do
//
//     final routeModel = routeModelFromJson(jsonString);

import 'dart:convert';

List<RoutesModel> routeModelFromJson(List<dynamic> str) =>
    List<RoutesModel>.from(str.map((x) => RoutesModel.fromJson(x)));

String routeModelToJson(List<RoutesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoutesModel {
  RoutesModel({
    this.authorRate,
    this.created,
    this.userId,
    this.name,
    this.modified,
    this.visibility,
    this.height,
    this.holds,
    this.id,
    this.userRateCount,
    this.ratePointTotal,
    this.isSelect =false
  });

  int? authorRate;
  int? created;
  String? userId;
  String? name;
  int? modified;
  dynamic visibility;
  int? height;
  String? holds;
  String? id;
  int? userRateCount;
  int? ratePointTotal;
  bool isSelect;

  factory RoutesModel.fromJson(Map<String, dynamic> json) => RoutesModel(
    authorRate: json["author_rate"],
    created: json["created"],
    userId: json["user_id"],
    name: json["name"],
    modified: json["modified"],
    visibility: json["visibility"],
    height: json["height"],
    holds: json["holds"],
    id: json["id"],
    userRateCount: json["user_rate_count"],
    ratePointTotal: json["rate_point_total"],
    isSelect: false,
  );

  Map<String, dynamic> toJson() => {
    "author_rate": authorRate,
    "created": created,
    "user_id": userId,
    "name": name,
    "modified": modified,
    "visibility": visibility,
    "height": height,
    "holds": holds,
    "id": id,
    "user_rate_count": userRateCount,
    "rate_point_total": ratePointTotal,
    "isSelect": isSelect,
  };
}
