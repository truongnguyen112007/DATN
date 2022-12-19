import 'dart:async';
import 'dart:math';

import 'package:base_bloc/data/eventbus/new_page_event.dart';
import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/data/model/info_route_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_page.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import '../../localization/locale_keys.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/toast_utils.dart';
import '../create_info_route/create_info_route_page.dart';
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

  void confirmOnclick(BuildContext context, InfoRouteModel? infoRouteModel) {
    var lHoldSet = <HoldSetModel>[];
    for (int i = 0; i < state.lRoutes.length; i++) {
      if (state.lRoutes[i].fileName != null &&
          state.lRoutes[i].fileName!.isNotEmpty) {
        lHoldSet.add(state.lRoutes[i].copyOf(index: i));
      }
    }
    if (lHoldSet.isEmpty) {
      toast(LocaleKeys.please_input_hold_set.tr());
    } else {
      RouterUtils.openNewPage(
          CreateInfoRoutePage(
              lHoldParams:
                  Utils.getHoldsParam(state.lRoutes, state.row, state.column),
              infoRouteModel: infoRouteModel,
              lHoldSet: lHoldSet,
              routeModel: state.model,
              isEdit: state.isEdit),
          context);
    }
  }

  void itemOnClick(int index,int height, BuildContext context,InfoRouteModel? infoRouteModel) {
    /*   if (state.currentHoldSet.isNotEmpty) {
      state.lRoutes[index] = HoldSetModel(holdSet: state.currentHoldSet);
    }*/
    // emit(state.copyOf(selectIndex: index, lRoutes: state.lRoutes));
    RouterUtils.openNewPage(
        ZoomRoutesPage(heightOfRoute: height,
          infoRouteModel: infoRouteModel,
          model: state.model,
          isEdit: state.isEdit,
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
  void scaleOnClick(BuildContext context, int height,InfoRouteModel? infoRouteModel) {
    /*   if (state.currentHoldSet.isNotEmpty) {
      state.lRoutes[index] = HoldSetModel(holdSet: state.currentHoldSet);
    }*/
    // emit(state.copyOf(selectIndex: index, lRoutes: state.lRoutes));
    RouterUtils.openNewPage(
        ZoomRoutesPage(
          heightOfRoute: height,
          infoRouteModel: infoRouteModel,
            currentIndex: 0,
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
      bool? isEdit,
      required int column,
      required double sizeHoldSet,
      RoutesModel? model,
      required List<String> lHoldSetImage})  async{
    var isGuideline = await StorageUtils.getGuideline();
    var lHoldSet = <HoldSetModel>[];
    for (int i = 0; i < row * column; i++) {
      lHoldSet.add(HoldSetModel());
    }
    if (model != null) {
      var lHoldParam = Utils.getHold(model.holds);
      for (var element in lHoldParam) {
        lHoldSet[element.index] =HoldSetModel(
            index: element.index,
            rotate: element.rotate,
            fileName: element.imageUrl,
            id: element.hid);
      }
    }
    Timer(
        const Duration(seconds: 1),
        () => emit(state.copyOf(isEdit: isEdit,
            isShowGuideline: !isGuideline,
            status: StatusType.success,
            column: column,
            model: model,
            row: row,
            sizeHoldSet: sizeHoldSet,
            lRoutes: lHoldSet)));
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

  void showGuideline(bool isShow) {
    emit(state.copyOf(isShowGuideline: isShow));
    StorageUtils.saveGuideline(true);
  }}
