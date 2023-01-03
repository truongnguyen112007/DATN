import 'package:base_bloc/data/model/info_route_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/hold_set_model.dart';
import '../persons_page/persons_page_state.dart';

class ZoomRoutesState extends Equatable {
  final bool isEdit;
  final int column;
  final int row;
  final StatusType status;
  final double sizeHoldSet;
  final List<HoldSetModel> lHoldSet;
  final int? currentIndex;
  final int timeStamp;
  final String currentHoldSet;
  final double scale;
  final RoutesModel? model;
  final InfoRouteModel? infoRouteModel;
  int? holdSetIndex;

   ZoomRoutesState(
      {this.status = StatusType.initial,
        this.infoRouteModel,
        this.holdSetIndex=0,
        this.model,
        this.currentHoldSet = '',
        this.timeStamp = 0,
        this.isEdit = false,
        this.sizeHoldSet = 10,
        this.column = 0,
        this.scale =4.0,
        this.row = 0,
        this.currentIndex,
        this.lHoldSet = const <HoldSetModel>[]});

  ZoomRoutesState copyOf(
      {StatusType? status,
        RoutesModel? model,
        int? holdSetIndex,
        int? column,
        bool? isEdit,
        int? currentIndex,
        String? currentHoldSet,
        int? row,
        double? scale,
        double? sizeHoldSet,
        List<HoldSetModel>? lHoldSet,
          int? timeStamp}) =>
      ZoomRoutesState(
          holdSetIndex: holdSetIndex ?? this.holdSetIndex,
          model: model ?? this.model,
          isEdit: isEdit ?? this.isEdit,
          currentHoldSet: currentHoldSet ?? this.currentHoldSet,
          currentIndex: currentIndex ?? this.currentIndex,
          status: status ?? this.status,
          column: column ?? this.column,
          row: row ?? this.row,
          sizeHoldSet: sizeHoldSet ?? this.sizeHoldSet,
          lHoldSet: lHoldSet ?? this.lHoldSet,
          timeStamp: timeStamp ?? this.timeStamp,
          scale: scale ?? this.scale);

  @override
  List<Object?> get props => [
        holdSetIndex,
        model,
        isEdit,
        status,
        sizeHoldSet,
        column,
        row,
        lHoldSet,
        currentIndex,
        timeStamp,
        scale
      ];
}
