// To parse this JSON data, do
//
//     final CreateExportParam = CreateExportParamFromJson(jsonString);

import 'dart:convert';

CreateExportParam createExportParamFromJson(String str) => CreateExportParam.fromJson(json.decode(str));

String CreateExportParamToJson(CreateExportParam data) => json.encode(data.toJson());

class CreateExportParam {
  CreateExportParam({
    required this.customerId,
    required this.productList,
  });

  int customerId;
  List<Map<String, int>> productList;

  factory CreateExportParam.fromJson(Map<String, dynamic> json) => CreateExportParam(
    customerId: json["customerId"],
    productList: List<Map<String, int>>.from(json["productList"].map((x) => Map.from(x).map((k, v) => MapEntry<String, int>(k, v)))),
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "productList": List<dynamic>.from(productList.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}
