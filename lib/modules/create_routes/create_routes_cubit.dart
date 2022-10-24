import 'dart:async';

import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import '../../router/router_utils.dart';
import '../hold_set/hold_set_page.dart';

class CreateRoutesCubit extends Cubit<CreateRoutesState> {
  CreateRoutesCubit() : super(const CreateRoutesState());

  void itemOnLongPress(int index, BuildContext context) async {
    emit(state.copyOf(selectIndex: index));
    var result = await RouterUtils.openNewPage(const HoldSetPage(), context);
    if (result != null) {
      state.lRoutes[index] =
          HoldSetModel(holdSet: result, rotate: state.lRoutes[index].rotate);
      emit(state.copyOf(
          currentHoldSet: result,
          lRoutes: state.lRoutes,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  void itemOnClick(int index) {
    /*   if (state.currentHoldSet.isNotEmpty) {
      state.lRoutes[index] = HoldSetModel(holdSet: state.currentHoldSet);
    }*/
    emit(state.copyOf(selectIndex: index, lRoutes: state.lRoutes));
  }

  void turnLeftOnClick(BuildContext context) {
    var rotate = state.lRoutes[state.selectIndex!].rotate - 1;
    state.lRoutes[state.selectIndex!] =
        state.lRoutes[state.selectIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lRoutes: state.lRoutes));
  }

  void turnRightOnClick(BuildContext context) {
    var rotate = state.lRoutes[state.selectIndex!].rotate + 1;
    state.lRoutes[state.selectIndex!] =
        state.lRoutes[state.selectIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lRoutes: state.lRoutes));
  }

  void setData(
      {required int row, required int column, required double sizeHoldSet}) {
    var lRoutes = <HoldSetModel>[];
    for (int i = 0; i < row * column; i++) {
      lRoutes.add(HoldSetModel());
    }
    Timer(
        const Duration(seconds: 1),
        () => emit(state.copyOf(
            status: StatusType.success,
            column: column,
            row: row,
            sizeHoldSet: sizeHoldSet,
            lRoutes: lRoutes)));
  }

  void holdSetOnClick(BuildContext context) =>
      RouterUtils.openNewPage(const HoldSetPage(), context);

  void deleteOnclick() {
    if (state.selectIndex != null) {
      state.lRoutes[state.selectIndex!] = HoldSetModel(holdSet: '');
      emit(state.copyOf(
          currentHoldSet: '',
          lRoutes: state.lRoutes,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  final List<String> lHoldSet = [
    Assets.svg.holdset1,
    Assets.svg.holdset2,
    Assets.svg.holdset3,
    Assets.svg.holdset4,
    Assets.svg.holdset5
  ];
}
