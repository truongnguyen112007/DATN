import 'dart:async';

import 'package:base_bloc/data/model/info_route_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_page.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/eventbus/new_page_event.dart';
import '../../data/model/hold_set_model.dart';
import '../../localization/locale_keys.dart';
import '../../router/router_utils.dart';
import '../hold_set/hold_set_page.dart';
import '../persons_page/persons_page_state.dart';

class ZoomRoutesCubit extends Cubit<ZoomRoutesState> {
  ZoomRoutesCubit() : super(const ZoomRoutesState());

  Future<bool> goBack(BuildContext context) async {
    RouterUtils.pop(context, result: state.lRoutes);
    return false;
  }

  void setScale(int heightOfRoute) => emit(state.copyOf(
      scale: (state.scale == 1.2 || state.scale == 1.1)
          ? 2
          : (state.scale == 2
              ? 3
              : (state.scale == 3 ? 4 : (heightOfRoute == 12 ? 1.1 : 1.2)))));

  void itemOnLongPress(int index, BuildContext context) async {
    emit(state.copyOf(currentIndex: index));
    var result = await RouterUtils.openNewPage(const HoldSetPage(), context,
        type: NewPageType.HOLD_SET);
    if (result != null) {
      state.lRoutes[index] =
          HoldSetModel(holdSet: result, rotate: state.lRoutes[index].rotate);
      emit(state.copyOf(
          currentHoldSet: result,
          lRoutes: state.lRoutes,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  void setHoldSet(String holdSet) {
    state.lRoutes[state.currentIndex ?? 0] = HoldSetModel(
        holdSet: holdSet,
        rotate: state.lRoutes[state.currentIndex ?? 0].rotate);
    emit(state.copyOf(
        currentHoldSet: holdSet,
        lRoutes: state.lRoutes,
        timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void itemOnClick(int index, BuildContext context) {
    logE("TAG INDEX: $index");
    emit(state.copyOf(currentIndex: index));
  }

  void turnLeftOnClick(BuildContext context) {
    var rotate = state.lRoutes[state.currentIndex!].rotate - 1;
    state.lRoutes[state.currentIndex!] =
        state.lRoutes[state.currentIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lRoutes: state.lRoutes));
  }

  void turnRightOnClick(BuildContext context) {
    var rotate = state.lRoutes[state.currentIndex!].rotate + 1;
    state.lRoutes[state.currentIndex!] =
        state.lRoutes[state.currentIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lRoutes: state.lRoutes));
  }

  void setData(
          {required int row,
          required bool isEdit,
          required int column,
          RoutesModel? model,
          InfoRouteModel? infoRouteModel,
          required double sizeHoldSet,
          required List<HoldSetModel>? lRoutes,
          required int currentIndex}) =>
      Timer(
          const Duration(seconds: 1),
          () => emit(state.copyOf(
              model: model,
              isEdit: isEdit,
              currentIndex: currentIndex,
              status: StatusType.success,
              column: column,
              row: row,
              sizeHoldSet: sizeHoldSet,
              lRoutes: lRoutes)));

  void holdSetOnClick(BuildContext context) =>
      RouterUtils.openNewPage(const HoldSetPage(), context);

  void deleteOnclick() {
    if (state.currentIndex != null) {
      state.lRoutes[state.currentIndex!] = HoldSetModel(holdSet: '');
      emit(state.copyOf(
          currentHoldSet: '',
          lRoutes: state.lRoutes,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  void confirmOnclick(BuildContext context,InfoRouteModel? infoRouteModel) {
    var lHoldSet = <HoldSetModel>[];
    for (int i = 0; i < state.lRoutes.length; i++) {
      if (state.lRoutes[i].holdSet.isNotEmpty) {
        lHoldSet.add(state.lRoutes[i].copyOf(index: i));
      }
    }
    if (lHoldSet.isEmpty) {
      toast(LocaleKeys.please_input_hold_set.tr());
    } else {
      RouterUtils.openNewPage(
          CreateInfoRoutePage(
              infoRouteModel: infoRouteModel,
              lHoldSet: lHoldSet,
              routeModel: state.model,
              isEdit: state.isEdit),
          context);
    }
  }

  Offset getOffset(int currentIndex, double heightOfScreen, int heightOfRoute) {
    var dx = 0.0;
    var dy = 0.0;
    if (currentIndex % 12 == 0 ||
        currentIndex == 1 ||
        currentIndex == 2 ||
        currentIndex == 3 ||
        currentIndex == 4 ||
        currentIndex == 5 ||
        currentIndex % 12 == 1 ||
        currentIndex % 12 == 2 ||
        currentIndex % 12 == 3 ||
        currentIndex % 12 == 4 ||
        currentIndex % 12 == 5) {
      dx = heightOfScreen >= 800 ? 21 : 18;
    } else if (currentIndex == 12 ||
        currentIndex == 11 ||
        currentIndex == 10 ||
        currentIndex % 12 == 11 ||
        currentIndex % 12 == 10 ||
        currentIndex % 12 == 9 ||
        currentIndex % 12 == 8 ||
        currentIndex % 12 == 7) {
      dx = heightOfScreen >= 800 ? -21 : -18;
    }

    switch(heightOfRoute){
      case 3:{
        if(currentIndex<160){
          dy = heightOfScreen >= 800 ? 1 : 1;
        }else{
          dy = heightOfScreen >= 800 ? -1 : -1;
        }
      break;
      }
      case 6:{
          if (currentIndex <= 84) {
            dy = heightOfScreen >= 800 ? 83 : 73;
          } else if (currentIndex > 80 && currentIndex <= 150) {
            dy = 83;
          } else if (currentIndex > 150 && currentIndex < 250) {
            dy = 36;
          } else {
            dy = heightOfScreen >= 800 ? -83 : -73;
          }
          break;
        }
      case 9:{
        if (currentIndex <= 84) {
          dy = heightOfScreen >= 800 ? 160 : 146;
        } else if (currentIndex > 84 && currentIndex <= 156) {
          dy = 89;
        } else if (currentIndex > 156 && currentIndex < 252) {
          dy = 36;
        } else if (currentIndex > 252 && currentIndex < 324) {
          dy = 11;
        } else if (currentIndex > 324 && currentIndex < 396) {
          dy = -54;
        } else if (currentIndex > 396 && currentIndex < 468) {
          dy = -127;
        } else {
          dy = heightOfScreen >= 800 ? -166 : -146;
        }
        break;
      }
      case 12:
        if (currentIndex % 12 == 0 ||
            currentIndex == 1 ||
            currentIndex == 2 ||
            currentIndex == 3 ||
            currentIndex == 4 ||
            currentIndex == 5 ||
            currentIndex % 12 == 1 ||
            currentIndex % 12 == 2 ||
            currentIndex % 12 == 3 ||
            currentIndex % 12 == 4 ||
            currentIndex % 12 == 5) {
          dx = heightOfScreen >= 800 ? 26 : 14;
        } else if (currentIndex == 12 ||
            currentIndex == 11 ||
            currentIndex == 10 ||
            currentIndex % 12 == 11 ||
            currentIndex % 12 == 10 ||
            currentIndex % 12 == 9 ||
            currentIndex % 12 == 8 ||
            currentIndex % 12 == 7) {
          dx = heightOfScreen >= 800 ? -26 : -14;
        }

         if (currentIndex <= 80)                             dy = heightOfScreen >= 800 ? 215 : 175;
         else if (currentIndex > 80 && currentIndex <= 150)  dy = 200;
         else if (currentIndex > 150 && currentIndex <= 250) dy = 160;
         else if (currentIndex > 250 && currentIndex <= 350) dy = 70;
         else if (currentIndex > 350 && currentIndex <= 450) dy = 20;
         else if (currentIndex > 450 && currentIndex <= 550) dy = -80;
         else if (currentIndex > 550 && currentIndex <= 650) dy = -160;
         else                                                dy = heightOfScreen >= 800 ?-215 : -175;
        break;
      default:{
        if (currentIndex <= 84) {
          dy = heightOfScreen >= 800 ? 166 : 146;
        } else if (currentIndex > 84 && currentIndex <= 156) {
          dy = 89;
        } else if (currentIndex > 156 && currentIndex < 252) {
          dy = 36;
        } else if (currentIndex > 252 && currentIndex < 324) {
          dy = 11;
        } else if (currentIndex > 324 && currentIndex < 396) {
          dy = -54;
        } else if (currentIndex > 396 && currentIndex < 468) {
          dy = -127;
        } else {
          dy = heightOfScreen >= 800 ? -166 : -146;
        }
      }
    }
    return Offset(dx, dy);
  }

