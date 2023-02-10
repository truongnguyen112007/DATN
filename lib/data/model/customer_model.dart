// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<CustomerModel> customerModelFromJson(List<dynamic> str) =>
    List<CustomerModel>.from(str.map((x) => CustomerModel.fromJson(x)));

String customerModelToJson(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel {
  CustomerModel({
    required this.name,
    required this.phone,
    required this.price,
   /* required this.inventory,
    required this.image,
    required this.cost,
    required this.status,
    required this.createdAt,
    required this.updatedAt,*/
  });

  String name;
  String phone;
  int price;
  // String name;
  // String type;
  // String inventoryLevel;
  // String description;
  // int price;
  // int inventory;
  // String image;
  // String cost;
  // String status;
  // DateTime createdAt;
  // DateTime updatedAt;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    name: json["name"],
    phone: json["phone"],
    price: json["price"],
    // name: json["name"],
    // type: json["type"],
    // inventoryLevel: json["inventory_level"],
    // description: json["description"],
    // price: json["price"],
    // inventory: json["inventory"],
    // image: json["image"],
    // cost: json["cost"],
    // status: json["status"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "price": price,
    // "name": name,
    // "type": type,
    // "inventory_level": inventoryLevel,
    // "description": description,
    // "price": price,
    // "inventory": inventory,
    // "image": image,
    // "cost": cost,
    // "status": status,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
  };
}
