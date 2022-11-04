import 'package:equatable/equatable.dart';

import '../../data/model/hold_set_model.dart';
import '../persons_page/persons_page_state.dart';

class ZoomRoutesState extends Equatable {
  final int column;
  final int row;
  final StatusType status;
  final double sizeHoldSet;
  final List<HoldSetModel> lRoutes;
  final int? selectIndex;
  final int timeStamp;
  final String currentHoldSet;

  const ZoomRoutesState(
      {this.status = StatusType.initial,
        this.currentHoldSet = '',
        this.timeStamp = 0,
        this.sizeHoldSet = 10,
        this.column = 0,
        this.row = 0,
        this.selectIndex,
        this.lRoutes = const <HoldSetModel>[]});

  ZoomRoutesState copyOf(
      {StatusType? status,
        int? column,
        int? selectIndex,
        String? currentHoldSet,
        int? row,
        double? sizeHoldSet,
        List<HoldSetModel>? lRoutes,
        int? timeStamp}) =>
      ZoomRoutesState(
          currentHoldSet: currentHoldSet ?? this.currentHoldSet,
          selectIndex: selectIndex ?? this.selectIndex,
          status: status ?? this.status,
          column: column ?? this.column,
          row: row ?? this.row,
          sizeHoldSet: sizeHoldSet ?? this.sizeHoldSet,
          lRoutes: lRoutes ?? this.lRoutes,
          timeStamp: timeStamp ?? this.timeStamp);

  @override
  List<Object?> get props =>
      [status, sizeHoldSet, column, row, lRoutes, selectIndex, timeStamp];
}
