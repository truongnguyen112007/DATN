import 'dart:async';
import 'dart:math';

import 'package:base_bloc/components/visibility_route_widget.dart';
import 'package:base_bloc/data/eventbus/new_page_event.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/data/model/info_route_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_page.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../localization/locale_keys.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/toast_utils.dart';
import '../create_info_route/create_info_route_page.dart';
import '../hold_set/hold_set_page.dart';
import '../routers_detail/routes_detail_page.dart';

class CreateRoutesCubit extends Cubit<CreateRoutesState> {
  CreateRoutesCubit() : super(const CreateRoutesState());

  void itemOnLongPress(int index, BuildContext context) async {
    /*emit(state.copyOf(selectIndex: index));
    var result = await RouterUtils.openNewPage(const HoldSetPage(), context,
        type: NewPageType.HOLD_SET);
    if (result != null) {
      state.lHoldSet[index] =
          HoldSetModel(holdSet: result, rotate: state.lHoldSet[index].rotate);
      emit(state.copyOf(
          currentHoldSet: result,
          lHoldSet: state.lHoldSet,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }*/
  }

  void setHoldSets(List<HoldSetModel> list, int holdSetIndex) =>
      emit(state.copyOf(
          lHoldSet: list,
          holdSetIndex: holdSetIndex,
          timeStamp: DateTime.now().microsecondsSinceEpoch));

  void setHoldSet(String holdSet) {
    state.lHoldSet[state.selectIndex ?? 0] = HoldSetModel(
        holdSet: holdSet, rotate: state.lHoldSet[state.selectIndex ?? 0].rotate);
    emit(state.copyOf(
        currentHoldSet: holdSet,
        lHoldSet: state.lHoldSet,
        timeStamp: DateTime.now().microsecondsSinceEpoch));
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

  void itemOnClick(int index,int height, BuildContext context,InfoRouteModel? infoRouteModel) {
    RouterUtils.openNewPage(
        ZoomRoutesPage(heightOfRoute: height,
          infoRouteModel: infoRouteModel,
          holdSetIndex: state.holdSetIndex,
          model: state.model,
          isEdit: state.isEdit,
          currentIndex: index,
          row: state.row,
            lHoldSet: state.lHoldSet,
            column: state.column,
          sizeHoldSet: state.sizeHoldSet,
          heightOffScreen: MediaQuery.of(context).size.height,
        ),
        context,
        type: NewPageType.ZOOM_ROUTES);
  }
  void scaleOnClick(BuildContext context, int height,InfoRouteModel? infoRouteModel) {
    RouterUtils.openNewPage(
        ZoomRoutesPage(
          holdSetIndex: state.holdSetIndex,
          heightOfRoute: height,
          infoRouteModel: infoRouteModel,
            currentIndex: 0,
            row: state.row,
            lHoldSet: state.lHoldSet,
            column: state.column,
          sizeHoldSet: state.sizeHoldSet,
          heightOffScreen: MediaQuery.of(context).size.height,
        ),
        context,
        type: NewPageType.ZOOM_ROUTES);
  }

  void turnLeftOnClick(BuildContext context) {
    var rotate = state.lHoldSet[state.selectIndex!].rotate - 1;
    state.lHoldSet[state.selectIndex!] =
        state.lHoldSet[state.selectIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lHoldSet: state.lHoldSet));
  }

  void turnRightOnClick(BuildContext context) {
    var rotate = state.lHoldSet[state.selectIndex!].rotate + 1;
    state.lHoldSet[state.selectIndex!] =
        state.lHoldSet[state.selectIndex!].copyOf(rotate: rotate);
    emit(state.copyOf(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        lHoldSet: state.lHoldSet));
  }

  void setData(
      {required int row,
      bool? isEdit,
      required int column,
      required double sizeHoldSet,
      RoutesModel? model,
      required List<String> lHoldSetImage,required InfoRouteModel? infoRouteModel})  async{
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
            lHoldSet: lHoldSet)));
  }

  void deleteOnclick() {
    if (state.selectIndex != null) {
      state.lHoldSet[state.selectIndex!] = HoldSetModel(holdSet: '');
      emit(state.copyOf(
          currentHoldSet: '',
          lHoldSet: state.lHoldSet,
          timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  void showGuideline(bool isShow) {
    emit(state.copyOf(isShowGuideline: isShow));
    StorageUtils.saveGuideline(true);
  }
  void saveDaftOnClick(BuildContext context,
      InfoRouteModel? infoRouteModel,RoutesModel? routesModel) async {
    var routeModel = await Utils.saveDraft(
        routeModel: routesModel,
        context: context,
        infoRouteModel: infoRouteModel ??
            InfoRouteModel (
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
        column: state.column,
        isEdit: (routesModel != null && routesModel.userId == globals.userId));
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
