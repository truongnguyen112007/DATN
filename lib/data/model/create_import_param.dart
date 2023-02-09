// To parse this JSON data, do
//
//     final createImportParam = createImportParamFromJson(jsonString);

import 'dart:convert';

CreateImportParam createImportParamFromJson(String str) => CreateImportParam.fromJson(json.decode(str));

String createImportParamToJson(CreateImportParam data) => json.encode(data.toJson());

class CreateImportParam {
  CreateImportParam({
    required this.supplierId,
    required this.productList,
  });

  int supplierId;
  List<ProductList> productList;

  factory CreateImportParam.fromJson(Map<String, dynamic> json) => CreateImportParam(
    supplierId: json["supplierId"],
    productList: List<ProductList>.from(json["productList"].map((x) => ProductList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "supplierId": supplierId,
    "productList": List<dynamic>.from(productList.map((x) => x.toJson())),
  };
}

class ProductList {
  ProductList({
    required this.upcCode,
    required this.qty,
    required this.unitPrice,
    required this.name,
  });

  String upcCode;
  int qty;
  int unitPrice;
  String name;

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    upcCode: json["upcCode"],
    qty: json["qty"],
    unitPrice: json["unitPrice"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "upcCode": upcCode,
    "qty": qty,
    "unitPrice": unitPrice,
    "name": name,
  };
}
