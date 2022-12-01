import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_state.dart';
import 'package:base_bloc/modules/create_routes/create_routes_page.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/hold_set_model.dart';
import '../../data/model/info_route_model.dart';
import '../../localization/locale_keys.dart';

class CreateInfoRouteCubit extends Cubit<CreateInfoRouteState> {
  final List<HoldSetModel>? lHoldSet;
  var userRepository = UserRepository();

  CreateInfoRouteCubit(this.lHoldSet) : super(const CreateInfoRouteState());

  void setData(RoutesModel? routesModel, InfoRouteModel? infoRouteModel) {
    if (routesModel != null) {
      var currentIndex = 0;
      for (int i = 0; i < lGrade.length; i++) {
        if (lGrade[i] == routesModel.authorGrade) {
          currentIndex = i;
          break;
        }
      }
      emit(state.copyOf(isEdit: true,
          model: routesModel,
          isCorner: routesModel.hasConner ?? false,
          currentIndexGrade: currentIndex,
          grade: routesModel.authorGrade,
          routeName: routesModel.name ?? ''));
    }
    if (infoRouteModel != null) {
      var currentIndex = 0;
      for (int i = 0; i < lGrade.length; i++) {
        if (lGrade[i] == infoRouteModel.grade) {
          currentIndex = i;
          break;
        }
      }
      emit(state.copyOf(
          isCorner: infoRouteModel.isCorner,
          currentIndexGrade: currentIndex,
          grade: infoRouteModel.grade,
          routeName: infoRouteModel.routeName));
    }
  }

  void increase() {
    if (state.currentIndexGrade == lGrade.length-1) return;
    emit(state.copyOf(
        grade: lGrade[state.currentIndexGrade + 1],
        currentIndexGrade: state.currentIndexGrade + 1));
  }

  void decrease() {
    if (state.currentIndexGrade == 0) return;
    emit(state.copyOf(
        grade: lGrade[state.currentIndexGrade - 1],
        currentIndexGrade: state.currentIndexGrade - 1));
  }

  void setCorner() => emit(state.copyOf(isCorner: !state.isCorner));

  void publishOnclick(
      bool isPublish, String routeName, BuildContext context) async {
    if(!isValid(routeName)) return;
    Utils.hideKeyboard(context);
    if (!isPublish) {
      // create info before create route
      RouterUtils.openNewPage(
          CreateRoutesPage(
              infoRouteModel: InfoRouteModel(
                  grade: state.grade,
                  routeName: routeName,
                  isCorner: state.isCorner)),
          context);
      return;
    }
    Dialogs.showLoadingDialog(context);
    var response = !state.isEdit
        ? await userRepository.createRoute(
            name: routeName,
            lHold: lHoldSet!.map((e) => e.index).toList(),
            hasCorner: state.isCorner,
            authorGrade: state.grade)
        : await userRepository.editRoute(
            name: routeName,
            lHold: lHoldSet!.map((e) => e.index).toList(),
            hasCorner: state.isCorner,
            authorGrade: state.grade,
            routeId: state.model?.id ?? '');
    await Dialogs.hideLoadingDialog();
    if (response.error != null) {
      toast(response.error.toString());
    } else {
      toast(response.message.toString());
      RouterUtils.openNewPage(const HomePage(), context, isReplace: true);
    }
  }

  bool isValid(String routeName) {
    if (routeName.isEmpty) {
      emit(state.copyOf(
        errorRouteName: LocaleKeys.please_input_hold_set.tr(),
      ));
      return false;
    } else {
      emit(state.copyOf(errorRouteName: ''));
    }
    return true;
  }

  var lGrade = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20];
}
