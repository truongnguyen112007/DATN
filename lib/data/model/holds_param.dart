List<HoldParam> holdParamFromJson(List<dynamic> str) =>
    List<HoldParam>.from(str.map((x) => HoldParam.fromJson(x)));

class HoldParam {
  final int x;
  final int y;
  final int hid;
  final String d;
  int index;
  String imageUrl;
  int rotate;

  HoldParam(this.x, this.y, this.hid, this.d,
      {this.index = 0, this.imageUrl = '', this.rotate = 0});

  factory HoldParam.fromJson(Map<String, dynamic> json) =>
      HoldParam(json["x"], json["y"], json["hid"], json["d"]);

  Map<String, dynamic> toJson() => {"x": x, "y": y, "hid": hid, "d": d};
}
