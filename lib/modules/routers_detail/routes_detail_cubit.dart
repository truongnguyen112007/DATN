import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_page.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_page.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/dialogs.dart';
import '../../data/globals.dart' as globals;
import '../../router/router_utils.dart';
import '../../utils/toast_utils.dart';
import '../create_routes/create_routes_page.dart';

class RoutesDetailCubit extends Cubit<RoutesDetailState> {
  var userRepository = UserRepository();

  RoutesDetailCubit(RoutesModel model)
      : super(RoutesDetailState(status: RoutesStatus.initial, model: model)) {
    Timer(const Duration(seconds: 1),
        () => emit(state.copyOf(status: RoutesStatus.success)));
  }

  void handleAction(RoutesAction action, BuildContext context) {
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

  void editRouteOnclick(BuildContext context, RoutesModel model) async {
    var lHoldSet = <HoldSetModel>[];
    var random = Random();
    List<int> lHoldSetInt = json.decode(model.holds ?? '').cast<int>();
    for (var element in lHoldSetInt) {
      lHoldSet.add(HoldSetModel(
          holdSet: globals.lHoldSet[random.nextInt(globals.lHoldSet.length)],
          index: element));
    }
    RouterUtils.openNewPage(
        CreateInfoRoutePage(
          lHoldSet: lHoldSet,
          isEdit: true,
          model: model,
        ),
        context);
  }
}
