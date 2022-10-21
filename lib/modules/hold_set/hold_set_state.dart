import 'package:base_bloc/modules/hold_set/hold_set_cubit.dart';
import 'package:equatable/equatable.dart';

enum SelectType { ALL, FAVOURITE }

class HoldSetState extends Equatable {
  final int currentIndex;
  final SelectType type;
  final List<HoldModel> lHoldSet;

  const HoldSetState(
      {this.currentIndex = 0,
      this.type = SelectType.ALL,
      this.lHoldSet = const <HoldModel>[]});

  HoldSetState copyOf(
          {int? currentIndex, SelectType? type, List<HoldModel>? lHoldSet}) =>
      HoldSetState(
          lHoldSet: lHoldSet ?? this.lHoldSet,
          currentIndex: currentIndex ?? this.currentIndex,
          type: type ?? this.type);

  @override
  List<Object?> get props => [currentIndex, type, lHoldSet];
}
