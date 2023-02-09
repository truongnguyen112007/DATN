import 'package:base_bloc/data/model/routes_model.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/hold_set_model.dart';
import '../persons_page/persons_page_state.dart';

class CreateRoutesState extends Equatable {
  final int column;
  final int row;
  final StatusType status;
  final double sizeHoldSet;
  final List<HoldSetModel> lHoldSet;
  final int? selectIndex;
  final int timeStamp;
  final String currentHoldSet;
  final bool isEdit;
  final RoutesModel? model;
  final bool isShowGuideline;
  final int? holdSetIndex;

  const CreateRoutesState(
      {this.status = StatusType.initial,
      this.model,
      this.holdSetIndex = 0,
      this.isShowGuideline = true,
      this.isEdit = false,
      this.currentHoldSet = '',
      this.timeStamp = 0,
      this.sizeHoldSet = 10,
      this.column = 0,
      this.row = 0,
      this.selectIndex,
      this.lHoldSet = const <HoldSetModel>[]});

  CreateRoutesState copyOf(
          {StatusType? status,
          RoutesModel? model,
          int? holdSetIndex,
          int? column,
          bool? isEdit,
          int? selectIndex,
          String? currentHoldSet,
          int? row,
          bool? isShowGuideline,
          double? sizeHoldSet,
          List<HoldSetModel>? lHoldSet,
          int? timeStamp}) =>
      CreateRoutesState(
          holdSetIndex: holdSetIndex ?? this.holdSetIndex,
          isShowGuideline: isShowGuideline ?? this.isShowGuideline,
          model: model ?? this.model,
          isEdit: isEdit ?? this.isEdit,
          currentHoldSet: currentHoldSet ?? this.currentHoldSet,
          selectIndex: selectIndex ?? this.selectIndex,
          status: status ?? this.status,
          column: column ?? this.column,
          row: row ?? this.row,
          sizeHoldSet: sizeHoldSet ?? this.sizeHoldSet,
          lHoldSet: lHoldSet ?? this.lHoldSet,
          timeStamp: timeStamp ?? this.timeStamp);

  @override
  List<Object?> get props => [
        isShowGuideline,
        status,
        sizeHoldSet,
        column,
        row,
        lHoldSet,
        selectIndex,
        timeStamp,
        isEdit
      ];
}
