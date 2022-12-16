class HoldParam {
  final int x;
  final int y;
  final int hid;
  final String d;

  HoldParam(this.x, this.y, this.hid, this.d);

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
        "hid": hid,
        "d": d,
      };
}
