
List<HoldSetModel> holdSetModelFromJson(List<dynamic> str) =>
    List<HoldSetModel>.from(str.map((x) => HoldSetModel.fromJson(x)));

class HoldSetModel {
  int? id;
  int? created;
  int? ownerId;
  int? status;
  String? fileName;
  int? modified;
  String? name;

  String holdSet;
  int rotate;
  int index;

  HoldSetModel({
    this.holdSet = '',
    this.rotate = 0,
    this.index = 0,
    this.id,
    this.created,
    this.ownerId,
    this.status,
    this.fileName,
    this.modified,
    this.name,
  });

  HoldSetModel copyOf(
          {String? holdSet,
          int? rotate,
          int? index,
          int? id,
          int? created,
          int? ownerId,
          int? status,
          String? fileName,
          int? modified,
          String? name}) =>
      HoldSetModel(
          id: id ?? this.id,
          created: created ?? this.created,
          ownerId: ownerId ?? this.ownerId,
          status: status ?? this.status,
          fileName: fileName ?? this.fileName,
          holdSet: holdSet ?? this.holdSet,
          rotate: rotate ?? this.rotate,
          index: index ?? this.index);

  factory HoldSetModel.fromJson(Map<String, dynamic> json) => HoldSetModel(
        id: json["id"],
        created: json["created"],
        ownerId: json["owner_id"],
        status: json["status"],
        fileName: json["file_name"],
        modified: json["modified"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created,
        "owner_id": ownerId,
        "status": status,
        "file_name": fileName,
        "modified": modified,
        "name": name,
      };
}
