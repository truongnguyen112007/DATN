import 'dart:async';

import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/modules/designed/designed_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';

import '../../components/dialogs.dart';
import '../../data/eventbus/refresh_event.dart';
import '../../data/globals.dart';
import '../../data/model/routes_model.dart';
import '../../data/repository/user_repository.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../create_info_route/create_info_route_page.dart';
import '../create_routes/create_routes_page.dart';
import '../filter_routes/filter_routes_page.dart';
import '../playlist/playlist_cubit.dart';
import '../routers_detail/routes_detail_page.dart';
import '../tab_home/tab_home_state.dart';

class DesignedCubit extends Cubit<DesignedState> {
  var userRepository = UserRepository();

  DesignedCubit() : super(const DesignedState()) {
    if (state.status == FeedStatus.initial) {
      getRoute();
    }
  }

  onRefresh() {
    emit(const DesignedState(status: FeedStatus.refresh));
    getRoute();
  }

  void itemOnLongClick(BuildContext context, int index,
      {bool isMultiSelect = false, RoutesModel? model, bool isCopy = true}) {
    var count = 0;
    for (var element in state.lRoutes) {
      if (element.isSelect) count++;
    }
    Utils.showActionDialog(context, (type) {
      Navigator.of(context, rootNavigator: true).pop();
      switch (type) {
        case ItemAction.ADD_TO_FAVOURITE:
          addToFavourite(context, model: model, isMultiSelect: isMultiSelect);
          return;
        case ItemAction.DELETE:
          if (isMultiSelect) return;
          deleteRoute(context, model!, index);
          return;
        case ItemAction.ADD_TO_PLAYLIST:
          addToPlaylist(context, isMultiSelect: isMultiSelect, model: model);
          return;
        case ItemAction.REMOVE_FROM_FAVORITE:
          removeFromFavourite(
              context, model: model, index, isMultiSelect: isMultiSelect);
          return;
        case ItemAction.SHARE:
          if (isMultiSelect) return;
          shareRoutes(context, model!, index);
          return;
        case ItemAction.EDIT:
          editRoutes(context, model!, index);
          return;
        case ItemAction.COPY:
          if (isMultiSelect) return;
          copyRoutes(context, model!, index);
          return;
      }
    },
        isCopy: !isMultiSelect ? true : (count == 1 ? true : false),
        isDesigned: true);
  }

  void addToFavourite(BuildContext context,
      {RoutesModel? model, bool isMultiSelect = false}) async {
    Dialogs.showLoadingDialog(context);
    var lIds = <String>[];
    if (isMultiSelect) {
      for (int i = 0; i < state.lRoutes.length; i++) {
        if (state.lRoutes[i].isSelect) {
          lIds.add(state.lRoutes[i].id ?? '');
        }
      }
    } else {
      lIds.add(model!.id ?? "");
    }
    var response = await userRepository.addToFavorite(userId, lIds);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      toast(response.message);
      refreshRouteTab();
    } else {
      toast(response.error.toString());
    }
  }

  void refreshRouteTab() {
    Utils.fireEvent(RefreshEvent(RefreshType.PLAYLIST));
    Utils.fireEvent(RefreshEvent(RefreshType.FAVORITE));
  }

  void deleteRoute(BuildContext context, RoutesModel model, int index) async {
    Dialogs.showLoadingDialog(context);
    var response = await userRepository.deleteRoute(model.id ?? '');
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      state.lRoutes.removeAt(index);
      refreshRouteTab();
      emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
    } else {
      toast(response.error.toString());
    }
  }

  void handleAction(ItemAction action, RoutesModel model) =>
      logE("TAG ACTION: $action");

  void refresh() {
    Utils.fireEvent(RefreshEvent(RefreshType.FILTER));
    emit(
      const DesignedState(status: FeedStatus.refresh),
    );
    getRoute();
  }

  void createRoutesOnClick(BuildContext context) =>
      /*toast(LocaleKeys.thisFeatureIsUnder)*/
      RouterUtils.openNewPage(
          const CreateInfoRoutePage(isPublish: false), context);

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      FilterRoutesPage(
        showResultButton: (model) {},
        removeFilterCallBack: (model) {},
      ),
      context);

  void selectOnclick(bool isShowAdd) async {
    for (int i = 0; i < state.lRoutes.length; i++) {
      state.lRoutes[i].isSelect = false;
    }
    emit(state.copyWith(
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        isShowAdd: isShowAdd,
        isShowActionButton: false));
  }

  void itemOnclick(BuildContext context, RoutesModel model,int index) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
            publishCallback: () => publishRoute(index),
            index: BottomNavigationConstant.TAB_ROUTES,
            model: model,
          ),
          context);

  void publishRoute(int index) {
    state.lRoutes[index].published = true;
    emit(state.copyWith(timeStamp: DateTime
        .now()
        .microsecondsSinceEpoch));
  }

  void filterItemOnclick(int index) {
    state.lRoutes[index].isSelect = !state.lRoutes[index].isSelect;
    var isShowActionButton = false;
    for (int i = 0; i < state.lRoutes.length; i++) {
      if (state.lRoutes[i].isSelect == true) {
        isShowActionButton = true;
        break;
      }
    }
    emit(state.copyWith(
        isShowActionButton: isShowActionButton,
        lRoutes: state.lRoutes,
        timeStamp: DateTime.now().millisecondsSinceEpoch));
  }

  void getRoute({bool isPaging = false}) async {
    if (state.isLoading && state.lRoutes.isNotEmpty || state.isReadEnd) return;
    emit(state.copyWith(isLoading: true));
    var response = await userRepository.getRoute(nextPage: state.nextPage);
    if (response.data != null && response.error == null) {
      try {
        var lResponse = routeModelFromJson(response.data);
        emit(state.copyWith(
            status: FeedStatus.success,
            isReadEnd: lResponse.isEmpty,
            nextPage: state.nextPage + 1,
            isLoading: false,
            lRoutes:
                isPaging ? (state.lRoutes..addAll(lResponse)) : lResponse));
      } catch (e) {
        emit(state.copyWith(
            isReadEnd: true, isLoading: false, status: FeedStatus.failure));
      }
    } else {
      emit(state.copyWith(
          status: state.lRoutes.isNotEmpty
              ? FeedStatus.success
              : FeedStatus.failure,
          isReadEnd: true,
          isLoading: false));
      toast(response.error.toString());
    }
  }

  void removeFromFavourite(BuildContext context, int index,
      {RoutesModel? model, bool isMultiSelect = false}) async {
    Dialogs.showLoadingDialog(context);
    var routeIds = '';
    var lIndex = [];
    if (isMultiSelect) {
      for (int i = 0; i < state.lRoutes.length; i++) {
        if (state.lRoutes[i].isSelect) {
          routeIds += '${state.lRoutes[i].id ?? ''},';
          lIndex.add(i);
        }
      }
    } else {
      routeIds = model!.id ?? '';
    }
    var response = await userRepository.removeFromFavorite(routeIds);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      if (isMultiSelect) {
        for (int i = lIndex.length - 1; i >= 0; i--) {
          state.lRoutes.removeAt(lIndex[i]);
        }
        emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
      } else {
        state.lRoutes.removeAt(index);
        emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
      }
      refreshRouteTab();
    } else {
      toast(response.error.toString());
    }
  }

  void addToPlaylist(BuildContext context,
      {RoutesModel? model, bool isMultiSelect = false}) async {
    Dialogs.showLoadingDialog(context);
    var lRoutes = <String>[];
    if (isMultiSelect) {
      for (int i = 0; i < state.lRoutes.length; i++) {
        if (state.lRoutes[i].isSelect) {
          lRoutes.add(state.lRoutes[i].id ?? '');
        }
      }
    } else {
      lRoutes.add(model!.id ?? "");
    }
    var response = await userRepository.addToPlaylist(playlistId, lRoutes);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      toast(response.message);
      refreshRouteTab();
    } else {
      toast(response.error.toString());
    }
  }

  void shareRoutes(BuildContext context, RoutesModel model, int index) async {
    Dialogs.showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 1));
    await Dialogs.hideLoadingDialog();
    toast('Share post success');
  }

  void editRoutes(
      BuildContext context,
      RoutesModel model,
      int index,
      ) =>
      RouterUtils.openNewPage(
          CreateRoutesPage(model: model, isEdit: true), context);

  void copyRoutes(
    BuildContext context,
    RoutesModel model,
    int index,
  ) =>
      RouterUtils.openNewPage(
          CreateRoutesPage(model: model, isEdit: false), context);
}
