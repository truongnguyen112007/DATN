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
import '../../config/constant.dart';
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
    return true;
  }

  void setScale(int heightOfRoute) => emit(state.copyOf(
      scale: (state.scale == 1.2 || state.scale == 1.1)
          ? 2
          : (state.scale == 2
              ? 3
              : (state.scale == 3 ? 4 : (heightOfRoute == 12 ? 1.1 : 1.2)))));

  void itemOnLongPress(int index, BuildContext context) async {

    }
  }

  void setHoldSet(HoldSetModel holdSet, int holdSetIndex) {

  }

  void itemOnClick(int index, BuildContext context) =>
null;
  void turnLeftOnClick(BuildContext context) {

  }

  void turnRightOnClick(BuildContext context) {
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
  null;

  void holdSetOnClick(BuildContext context){}
  void deleteOnclick() {
  }

  void confirmOnclick(BuildContext context, InfoRouteModel? infoRouteModel) {
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
    }

