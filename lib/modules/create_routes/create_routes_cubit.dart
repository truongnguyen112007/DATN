import 'dart:async';
import 'dart:math';

import 'package:base_bloc/data/eventbus/new_page_event.dart';
import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_page.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../../gen/assets.gen.dart';
import '../../router/router_utils.dart';
import '../hold_set/hold_set_page.dart';

class CreateRoutesCubit extends Cubit<CreateRoutesState> {
  CreateRoutesCubit() : super(const CreateRoutesState());

  void itemOnLongPress(int index, BuildContext context) async {
    /*emit(state.copyOf(selectIndex: index));
    var result = await RouterUtils.openNewPage(const HoldSetPage(), context,
        type: NewPageType.HOLD_SET);
    if (result != null) {
      state.lRoutes[index] =
          HoldSetModel(holdSet: result, rotate: state.lRoutes[index].rotate);
      emit(state.copyOf(
          currentHoldSet: result,
          lRoutes: state.lRoutes,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }*/
  }

  void setHoldSets(List<HoldSetModel> list) =>
      emit(state.copyOf(lRoutes: list,timeStamp: DateTime.now().microsecondsSinceEpoch));

  void setHoldSet(String holdSet) {
    state.lRoutes[state.selectIndex ?? 0] = HoldSetModel(
        holdSet: holdSet, rotate: state.lRoutes[state.selectIndex ?? 0].rotate);
    emit(state.copyOf(
        currentHoldSet: holdSet,
        lRoutes: state.lRoutes,
        timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void itemOnClick(int index, BuildContext context) {
    /*   if (state.currentHoldSet.isNotEmpty) {
      state.lRoutes[index] = HoldSetModel(holdSet: state.currentHoldSet);
    }*/
    // emit(state.copyOf(selectIndex: index, lRoutes: state.lRoutes));
    RouterUtils.openNewPage(
        ZoomRoutesPage(
            currentIndex: index,
            row: state.row,
            lRoutes: state.lRoutes,
            column: state.column,
          sizeHoldSet: state.sizeHoldSet,
          heightOffScreen: MediaQuery.of(context).size.height,
        ),
        context,
        type: NewPageType.ZOOM_ROUTES);
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
      {required int row,
      required int column,
      required double sizeHoldSet,
      RoutesModel? model,
      required List<String> lHoldSetImage}) {
    var lRoutes = <HoldSetModel>[];
    for (int i = 0; i < row * column; i++) {
      lRoutes.add(HoldSetModel());
    }
    if (model != null) {
      var random = Random();
      List<int> lHoldSet = json.decode(model.holds ?? '').cast<int>();
      for (var element in lHoldSet) {
        if (element < lRoutes.length) {
          lRoutes[element].holdSet =
              lHoldSetImage[random.nextInt(lHoldSetImage.length)];
        }
      }
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


}
