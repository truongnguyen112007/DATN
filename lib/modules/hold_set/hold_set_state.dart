import 'package:equatable/equatable.dart';

enum SelectType { ALL, FAVOURITE }

class HoldSetState extends Equatable {
  final int currentIndex;
  final SelectType type;
  final List<String> lHoldSet;

  const HoldSetState(
      {this.currentIndex = 0,
      this.type = SelectType.ALL,
      this.lHoldSet = const <String>[]});

  HoldSetState copyOf(
          {int? currentIndex, SelectType? type, List<String>? lHoldSet}) =>
      HoldSetState(
          lHoldSet: lHoldSet ?? this.lHoldSet,
          currentIndex: currentIndex ?? this.currentIndex,
          type: type ?? this.type);

  @override
  List<Object?> get props => [currentIndex, type, lHoldSet];
}
