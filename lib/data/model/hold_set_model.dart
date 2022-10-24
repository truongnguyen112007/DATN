class HoldSetModel {
   String holdSet;
   int rotate;

  HoldSetModel({this.holdSet = '', this.rotate = 0});

  HoldSetModel copyOf({String? holdSet, int? rotate}) => HoldSetModel(
      holdSet: holdSet ?? this.holdSet, rotate: rotate ?? this.rotate);
}
