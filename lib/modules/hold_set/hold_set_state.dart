import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:equatable/equatable.dart';

enum SelectType { ALL, FAVOURITE }

enum HoldSetStatus { INITITAL, SUCCESS, ERROR }

class HoldSetState extends Equatable {
  final HoldSetStatus status;
  int currentIndex;
  final SelectType type;
  final List<HoldSetModel> lHoldSet;
  final bool isLoading;

   HoldSetState(
      {this.currentIndex = 0,
      this.status = HoldSetStatus.INITITAL,
      this.isLoading = true,
      this.type = SelectType.ALL,
      this.lHoldSet = const <HoldSetModel>[]});

  HoldSetState copyOf(
          {int? currentIndex,
          HoldSetStatus? status,
          SelectType? type,
          List<HoldSetModel>? lHoldSet,
          bool? isLoading}) =>
      HoldSetState(
          status: status ?? this.status,
          isLoading: isLoading ?? this.isLoading,
          lHoldSet: lHoldSet ?? this.lHoldSet,
          currentIndex: currentIndex ?? this.currentIndex,
          type: type ?? this.type);

  @override
  List<Object?> get props => [currentIndex, type, lHoldSet];
}
