import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/components/visibility_route_widget.dart';
import 'package:base_bloc/data/model/holds_param.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../data/model/hold_set_model.dart';
import '../../data/model/info_route_model.dart';
import '../../localization/locale_keys.dart';
import '../../theme/colors.dart';

class CreateInfoRouteCubit extends Cubit<CreateInfoRouteState> {
  final List<HoldSetModel>? lHoldSet;
  final List<HoldParam>? lHoldParams;
  final bool isEdit;
  var userRepository = UserRepository();

  CreateInfoRouteCubit(this.lHoldSet, this.lHoldParams, this.isEdit)
      : super(const CreateInfoRouteState()) {}

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
          height: routesModel.height ?? 3,
          visibilityType: (routesModel.visibility ?? 0) == ConstantKey.PRIVATE
              ? VisibilityType.PRIVATE
              : (routesModel.visibility ?? 0) == ConstantKey.FRIENDS
                  ? VisibilityType.FRIENDS
                  : VisibilityType.PUBLIC,
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
          visibilityType: infoRouteModel.type,
          height: infoRouteModel.height,
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

  void setCorner(BuildContext context) {
    Utils.hideKeyboard(context);
    emit(state.copyOf(isCorner: !state.isCorner));
  }

  void publishOnclick(
      bool isPublish, String routeName, BuildContext context,RoutesModel? routesModel) async {
    Utils.hideKeyboard(context);
    if(!isValid(routeName)) return;
    Utils.hideKeyboard(context);
    if (!isPublish) {
      // create info before create route
      RouterUtils.openNewPage(
          CreateRoutesPage(
              infoRouteModel: InfoRouteModel(
                  grade: state.grade,
                  routeName: routeName,
                  isCorner: state.isCorner,
                  height: state.height,
                  type: state.visibilityType)),
          context);
      return;
    }
    Dialogs.showLoadingDialog(context);
    var response = !isEdit
        ? await userRepository.createRoute(
            visibility: state.visibilityType == VisibilityType.PRIVATE
                ? ConstantKey.PRIVATE
                : (state.visibilityType == VisibilityType.FRIENDS
                    ? ConstantKey.FRIENDS
                    : ConstantKey.PUBLIC),
            height: state.height,
            name: routeName,
            lHold: lHoldParams ?? Utils.getHold(routesModel?.holds ?? ''),
            hasCorner: state.isCorner,
            authorGrade: state.grade)
        : await userRepository.editRoute(
            visibility: state.visibilityType == VisibilityType.PRIVATE
                ? 0
                : (state.visibilityType == VisibilityType.FRIENDS ? 1 : 2),
            height: state.height,
            name: routeName,
            lHold: lHoldParams ?? Utils.getHold(routesModel?.holds ?? ''),
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

  void changeHeight(int value,BuildContext context){
    Utils.hideKeyboard(context);
    emit(state.copyOf(height: value));
  }

  void visibilityOnClick(BuildContext context) {
    Utils.hideKeyboard(context);
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: colorTransparent,
        context: context,
        builder: (x) => VisibilityRouteWidget(
            itemOnClick: (type) {
              Utils.hideKeyboard(context);
              emit(state.copyOf(visibilityType: type));
              Navigator.pop(context);
            },
            type: state.visibilityType));
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
