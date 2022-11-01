import 'package:flutter/cupertino.dart';

class RoutesModel {
  final String name;
  final int height;
  final String author;
  final String grade;
  final String? status;
  bool isSelect;

  RoutesModel({
    required this.name,
    this.isSelect = false,
    required this.height,
    required this.author,
    required this.grade,
    this.status,
  });

  RoutesModel copyOf({String? name, int? height, String? author, String? grade,
    String? status, bool? isSelect}) =>
      RoutesModel(
          name: name ?? this.name,
          height: height ?? this.height,
          author: author ?? this.author,
          grade: grade ?? this.grade,
          status: status ?? this.status,
          isSelect: isSelect ?? this.isSelect);
}
