class HoldSetModel {
  String holdSet;
  int rotate;
  int index;

  HoldSetModel({this.holdSet = '', this.rotate = 0, this.index = 0});

  HoldSetModel copyOf({String? holdSet, int? rotate, int? index}) =>
      HoldSetModel(
          holdSet: holdSet ?? this.holdSet,
          rotate: rotate ?? this.rotate,
          index: index ?? this.index);
}
