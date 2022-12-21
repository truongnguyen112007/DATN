import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/localization/locale_keys.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_page.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_page.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/dialogs.dart';
import '../../data/globals.dart' as globals;
import '../../data/model/holds_param.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/toast_utils.dart';
import '../create_routes/create_routes_page.dart';

class RoutesDetailCubit extends Cubit<RoutesDetailState> {
  var userRepository = UserRepository();
  final bool isSaveDraft;

  RoutesDetailCubit(RoutesModel model, this.isSaveDraft)
      : super(RoutesDetailState(status: RoutesStatus.initial, model: model)) {
    getRouteDetail(model);
  }

  void getRouteDetail(RoutesModel model) async {
    var response = await userRepository.getRouteDetail(model.id ?? '');
    if (response.data != null && response.error == null) {
      Timer(
          const Duration(seconds: 1),
          () => emit(state.copyOf(
              status: RoutesStatus.success,
              model: RoutesModel.fromJson(response.data))));
    } else {
      toast(response.error.toString());
      emit(state.copyOf(status: RoutesStatus.failure));
    }
  }

  void handleAction(RoutesAction action, BuildContext context, VoidCallback? publishCallback) {
    switch (action) {
      case RoutesAction.INFO:
        return;
      case RoutesAction.COPY:
        copyRoutes(context, state.model);
        return;
      case RoutesAction.SHARE:
        shareRoutes(context, state.model);
        return;
      case RoutesAction.ADD_FAVOURITE:
        addToFavorite(context, state.model);
        return;
      case RoutesAction.ADD_TO_PLAY_LIST:
        addToPlaylist(context, state.model);
        return;
      case RoutesAction.PUBLISH:
        publishOnClick(state.model, context,publishCallback);
        return;
    }
  }

  void copyRoutes(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(CreateRoutesPage(model: model), context);

  void shareRoutes(BuildContext context, RoutesModel model) async {
    Dialogs.showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 1));
    await Dialogs.hideLoadingDialog();
    toast('Share post success');
  }

  void addToFavorite(BuildContext context, RoutesModel model) async {
    Dialogs.showLoadingDialog(context);
    var response =
        await userRepository.addToFavorite(globals.userId, [model.id ?? '']);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      toast(response.message);
    } else {
      toast(response.error.toString());
    }
  }

  void addToPlaylist(BuildContext context, RoutesModel model) async {
    Dialogs.showLoadingDialog(context);
    var response =
        await userRepository.addToFavorite(globals.userId, [model.id ?? '']);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      toast(response.message);
    } else {
      toast(response.error.toString());
    }
  }

  void publishOnClick(RoutesModel model, BuildContext context,
      VoidCallback? publishCallback) async {
    Dialogs.showLoadingDialog(context);
    var response = await userRepository.editRoute(
        routeId: model.id.toString(),
        visibility: model.visibility ?? 0,
        height: model.height ?? 9,
        name: model.name ?? '',
        lHold: Utils.getHold(model.holds ?? ''),
        hasCorner: model.hasConner ?? false,
        authorGrade: model.authorGrade ?? 0);
    await Dialogs.hideLoadingDialog();
    if (response.statusCode == 200 && response.error == null) {
      if (isSaveDraft) {
        RouterUtils.openNewPage(HomePage(), context, isReplace: true);
        return;
      }
      model.published = true;
      if (publishCallback != null) publishCallback.call();
      toast(LocaleKeys.publish_routes_success.tr());
      emit(state.copyOf(
          model: model, timeStamp: DateTime.now().microsecondsSinceEpoch));

    } else {
      toast(response.error.toString());
    }
  }

  void editRouteOnclick(BuildContext context, RoutesModel model) async {
    var lHoldSet = <HoldSetModel>[];
    var lHoldParam = Utils.getHold(model.holds ?? '');
    for (var element in lHoldParam) {
      lHoldSet.add(HoldSetModel(
          index: element.index,
          rotate: element.rotate,
          fileName: element.imageUrl,
          id: element.hid));
    }

    RouterUtils.openNewPage(
        CreateInfoRoutePage(
          lHoldSet: lHoldSet, isEdit: true, routeModel: model),
        context);
  }
}
