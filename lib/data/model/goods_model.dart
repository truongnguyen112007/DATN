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
    required this.barCode,
    required this.categoryId,
    required this.name,
    required this.type,
    required this.inventoryLevel,
    required this.description,
    required this.price,
    required this.inventory,
    required this.image,
    required this.cost,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String barCode;
  int categoryId;
  String name;
  String type;
  String inventoryLevel;
  String description;
  int price;
  int inventory;
  String image;
  String cost;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        barCode: json["bar_code"],
        categoryId: json["category_id"],
        name: json["name"],
        type: json["type"],
        inventoryLevel: json["inventory_level"],
        description: json["description"],
        price: json["price"],
    inventory: json["inventory"],
        image: json["image"],
        cost: json["cost"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bar_code": barCode,
        "category_id": categoryId,
        "name": name,
        "type": type,
        "inventory_level": inventoryLevel,
        "description": description,
        "price": price,
        "inventory": inventory,
        "image": image,
        "cost": cost,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
