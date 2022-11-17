import 'package:equatable/equatable.dart';

import '../../data/model/hold_set_model.dart';
import '../persons_page/persons_page_state.dart';

class ZoomRoutesState extends Equatable {
  final int column;
  final int row;
  final StatusType status;
  final double sizeHoldSet;
  final List<HoldSetModel> lRoutes;
  final int? currentIndex;
  final int timeStamp;
  final String currentHoldSet;
  final double scale;

  const ZoomRoutesState(
      {this.status = StatusType.initial,
        this.currentHoldSet = '',
        this.timeStamp = 0,
        this.sizeHoldSet = 10,
        this.column = 0,
        this.scale =4.0,
        this.row = 0,
        this.currentIndex,
        this.lRoutes = const <HoldSetModel>[]});

  ZoomRoutesState copyOf(
      {StatusType? status,
        int? column,
        int? currentIndex,
        String? currentHoldSet,
        int? row,
        double? scale,
        double? sizeHoldSet,
        List<HoldSetModel>? lRoutes,
        int? timeStamp}) =>
      ZoomRoutesState(
          currentHoldSet: currentHoldSet ?? this.currentHoldSet,
          currentIndex: currentIndex ?? this.currentIndex,
          status: status ?? this.status,
          column: column ?? this.column,
          row: row ?? this.row,
          sizeHoldSet: sizeHoldSet ?? this.sizeHoldSet,
          lRoutes: lRoutes ?? this.lRoutes,
          timeStamp: timeStamp ?? this.timeStamp,
          scale: scale ?? this.scale);

  @override
  List<Object?> get props => [
        status,
        sizeHoldSet,
        column,
        row,
        lRoutes,
        currentIndex,
        timeStamp,
        scale
      ];
}
