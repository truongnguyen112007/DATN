// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(List<dynamic> str) =>
    List<ProductModel>.from(str.map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    required this.id,
    required this.shopId,
    required this.categoryId,
    required this.name,
    required this.sku,
    required this.upcCode,
    required this.description,
    required this.price,
    required this.inStock,
    this.image,
    required this.unit,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int shopId;
  int categoryId;
  String name;
  String sku;
  String upcCode;
  String description;
  int price;
  int inStock;
  dynamic image;
  String unit;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        shopId: json["shop_id"],
        categoryId: json["category_id"],
        name: json["name"],
        sku: json["sku"],
        upcCode: json["upc_code"],
        description: json["description"],
        price: json["price"],
        inStock: json["in_stock"],
        image: json["image"],
        unit: json["unit"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "category_id": categoryId,
        "name": name,
        "sku": sku,
        "upc_code": upcCode,
        "description": description,
        "price": price,
        "in_stock": inStock,
        "image": image,
        "unit": unit,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
