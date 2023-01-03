import 'dart:async';

import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/data/model/info_route_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_page.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import '../../components/visibility_route_widget.dart';
import '../../config/constant.dart';
import '../../data/eventbus/list_hold_set_event.dart';
import '../../data/eventbus/new_page_event.dart';
import '../../data/model/hold_set_model.dart';
import '../../localization/locale_keys.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../hold_set/hold_set_page.dart';
import '../persons_page/persons_page_state.dart';
import '../routers_detail/routes_detail_page.dart';
import 'dart:io';

class ZoomRoutesCubit extends Cubit<ZoomRoutesState> {
  var userRepository = UserRepository();
  ZoomRoutesCubit() : super(ZoomRoutesState());

  Future<bool> goBack(BuildContext context) async {
    RouterUtils.pop(context,
        result: ListHoldSetEvent(state.lHoldSet, state.holdSetIndex ?? 0));
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
    var result = await RouterUtils.openNewPage(
        HoldSetPage(holdSetIndex: state.holdSetIndex), context,
        type: NewPageType.HOLD_SET);
    if (result != null) {
      state.lHoldSet[index] =
          HoldSetModel(holdSet: result, rotate: state.lHoldSet[index].rotate);
      emit(state.copyOf(
          currentHoldSet: result,
          lHoldSet: state.lHoldSet,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  void setHoldSet(HoldSetModel holdSet, int holdSetIndex) {
    state.lHoldSet[state.currentIndex ?? 0] =
        holdSet.copyOf(rotate: state.lHoldSet[state.currentIndex ?? 0].rotate);
    emit(state.copyOf(
        holdSetIndex: holdSetIndex,
        currentHoldSet: "",
        timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void itemOnClick(int index, BuildContext context) =>
      emit(state.copyOf(currentIndex: index));

  void turnLeftOnClick(BuildContext context) {
    var rotate = state.lHoldSet[state.currentIndex!].rotate - 1;
    if (rotate == -4) rotate = 0;
    state.lHoldSet[state.currentIndex!] =
        state.lHoldSet[state.currentIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lHoldSet: state.lHoldSet));
  }

  void turnRightOnClick(BuildContext context) {
    var rotate = state.lHoldSet[state.currentIndex!].rotate + 1;
    if (rotate == 4) rotate = 0;
    state.lHoldSet[state.currentIndex!] =
        state.lHoldSet[state.currentIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lHoldSet: state.lHoldSet));
  }

  void setData(
          {required int row,
          required bool isEdit,
          required int column,
          int holdSetIndex = 0,
          RoutesModel? model,
          InfoRouteModel? infoRouteModel,
          required double sizeHoldSet,
          required List<HoldSetModel>? lHoldSet,
          required int currentIndex}) =>
      Timer(
          const Duration(seconds: 1),
          () => emit(state.copyOf(
              holdSetIndex: holdSetIndex,
              model: model,
              isEdit: isEdit,
              currentIndex: currentIndex,
              status: StatusType.success,
              column: column,
              row: row,
              sizeHoldSet: sizeHoldSet,
              lHoldSet: lHoldSet)));

  void holdSetOnClick(BuildContext context) => RouterUtils.openNewPage(
      HoldSetPage(holdSetIndex: state.holdSetIndex), context);

  void deleteOnclick() {
    if (state.currentIndex != null) {
      state.lHoldSet[state.currentIndex!] = HoldSetModel(holdSet: '');
      emit(state.copyOf(
          currentHoldSet: '',
          lHoldSet: state.lHoldSet,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  void confirmOnclick(BuildContext context, InfoRouteModel? infoRouteModel) {
    var lHoldSet = <HoldSetModel>[];
    for (int i = 0; i < state.lHoldSet.length; i++) {
      if (state.lHoldSet[i].fileName != null &&
          state.lHoldSet[i].fileName!.isNotEmpty) {
        lHoldSet.add(state.lHoldSet[i].copyOf(index: i));
      }
    }
    if (lHoldSet.isEmpty) {
      toast(LocaleKeys.please_input_hold_set.tr());
    } else {
      RouterUtils.openNewPage(
          CreateInfoRoutePage(
              lHoldParams:
                  Utils.getHoldsParam(state.lHoldSet, state.row, state.column),
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
      dx = Platform.isAndroid
          ? heightOfScreen >= 800
              ? 21
              : 18
          : heightOfScreen >= 800
              ? 25
              : 22;
    } else if (currentIndex == 12 ||
        currentIndex == 11 ||
        currentIndex == 10 ||
        currentIndex % 12 == 11 ||
        currentIndex % 12 == 10 ||
        currentIndex % 12 == 9 ||
        currentIndex % 12 == 8 ||
        currentIndex % 12 == 7) {
      dx = Platform.isAndroid
          ? heightOfScreen >= 800
              ? -21
              : -18
          : heightOfScreen >= 800
              ? -25
              : -22;
    }

    switch (heightOfRoute) {
      case 3:
        {
          if (currentIndex < 160) {
            dy = Platform.isAndroid
                ? heightOfScreen >= 800
                    ? -1
                    : -1
                : heightOfScreen >= 800
                    ? -3
                    : -3;
          } else {
            dy = Platform.isAndroid
                ? heightOfScreen >= 800
                    ? 1
                    : 1
                : heightOfScreen >= 800
                    ? 3
                    : 3;
          }
          break;
        }
      case 6:
        {
          if (currentIndex <= 84) {
            dy = Platform.isAndroid
                ? heightOfScreen >= 800
                    ? -83
                    : -73
                : heightOfScreen >= 800
                    ? -93
                    : -83;
            ;
          } else if (currentIndex > 80 && currentIndex <= 150) {
            dy = 36;
          } else if (currentIndex > 150 && currentIndex < 250) {
            dy = 36;
          } else {
            dy = Platform.isAndroid
                ? heightOfScreen >= 800
                    ? 83
                    : 73
                : heightOfScreen >= 800
                    ? 93
                    : 83;
          }
          break;
        }
      case 9:
        {
          if (currentIndex <= 84) {
            dy = Platform.isAndroid
                ? heightOfScreen >= 800
                    ? -166
                    : -146
                : heightOfScreen >= 800
                    ? -175
                    : -155;
          } else if (currentIndex > 84 && currentIndex <= 156) {
            dy = -127;
          } else if (currentIndex > 156 && currentIndex < 252) {
            dy = -54;
          } else if (currentIndex > 252 && currentIndex < 324) {
            dy = 11;
          } else if (currentIndex > 324 && currentIndex < 396) {
            dy = 36;
          } else if (currentIndex > 396 && currentIndex < 468) {
            dy = 89;
          } else {
            dy = Platform.isAndroid
                ? heightOfScreen >= 800
                    ? 160
                    : 146
                : heightOfScreen >= 800
                    ? 175
                    : 155;
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
          dx = Platform.isAndroid
              ? heightOfScreen >= 800
                  ? 26
                  : 14
              : heightOfScreen >= 800
                  ? 16
                  : 24;
        } else if (currentIndex == 12 ||
            currentIndex == 11 ||
            currentIndex == 10 ||
            currentIndex % 12 == 11 ||
            currentIndex % 12 == 10 ||
            currentIndex % 12 == 9 ||
            currentIndex % 12 == 8 ||
            currentIndex % 12 == 7) {
          dx = Platform.isAndroid
              ? heightOfScreen >= 800
                  ? -26
                  : -14
              : heightOfScreen >= 800
                  ? -16
                  : -24;
        }

        if (currentIndex <= 80)
          dy = Platform.isAndroid
              ? heightOfScreen >= 800
                  ? -215
                  : -175
              : heightOfScreen >= 800
                  ? -220
                  : -180;
        else if (currentIndex > 80 && currentIndex <= 150)
          dy = -200;
        else if (currentIndex > 150 && currentIndex <= 250)
          dy = -160;
        else if (currentIndex > 250 && currentIndex <= 350)
          dy = -80;
        else if (currentIndex > 350 && currentIndex <= 450)
          dy = 20;
        else if (currentIndex > 450 && currentIndex <= 550)
          dy = 70;
        else if (currentIndex > 550 && currentIndex <= 650)
          dy = 160;
        else
          dy = Platform.isAndroid
              ? heightOfScreen >= 800
                  ? 215
                  : 175
              : heightOfScreen >= 800
                  ? 220
                  : 180;
        break;
      default:
        {
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

  void saveDaftOnClick(BuildContext context, InfoRouteModel? infoRouteModel,
      RoutesModel? routesModel) async {
    var routeModel = await Utils.saveDraft(
        isEdit: (routesModel != null && routesModel.userId == globals.userId),
        routeModel: routesModel,
        context: context,
        infoRouteModel: infoRouteModel ??
            InfoRouteModel(
                grade: routesModel?.authorGrade ?? 0,
                routeName: routesModel?.name ?? '',
                isCorner: routesModel?.hasConner ?? false,
                height: routesModel?.height ?? 9,
                type: (routesModel?.visibility ?? 0) == ConstantKey.PRIVATE
                    ? VisibilityType.PRIVATE
                    : (routesModel?.visibility ?? 0) == ConstantKey.PUBLIC
                        ? VisibilityType.PUBLIC
                        : VisibilityType.FRIENDS),
        lHoldSet: state.lHoldSet,
        row: state.row,
        column: state.column);
    if (routeModel != null) {
      RouterUtils.openNewPage(
          RoutesDetailPage(
              isSaveDraft: true,
              index: BottomNavigationConstant.TAB_ROUTES,
              model: routeModel),
          context);
    }
  }
}
