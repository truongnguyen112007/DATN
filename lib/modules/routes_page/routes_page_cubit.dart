import 'dart:async';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/favourite/favourite_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_state.dart';
import 'package:base_bloc/modules/routes_page/routes_page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';
import '../../components/dialogs.dart';
import '../../components/filter_widget.dart';
import '../../config/constant.dart';
import '../../data/eventbus/refresh_event.dart';
import '../../data/model/routes_model.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../../utils/toast_utils.dart';
import '../filter_routes/filter_routes_page.dart';
import '../playlist/playlist_cubit.dart';
import '../routers_detail/routes_detail_page.dart';
import 'package:base_bloc/data/globals.dart' as globals;

class RoutesPageCubit extends Cubit<RoutesPageState> {
  var userRepository = UserRepository();

  RoutesPageCubit() : super(RoutesPageState()) {
    if (state.status == RouteStatus.initial) {
      emit(state.copyWith(status: RouteStatus.success));
      getRoutes();
    }
  }

  getRoutes({bool isPaging = false}) {
    if (state.isReadEnd || state.isLoading) return;
    if (isPaging) {
      search(state.keySearch, state.nextPage, isPaging: true);
    } else {
      search(state.keySearch, state.nextPage);
    }
  }

  setIndex(int newIndex, int oldIndex) {
    var lResponse = state.lRoutes;
    var newItem = lResponse.removeAt(oldIndex);
    lResponse.insert(newIndex, newItem);
    emit(state.copyWith(lRoutes: lResponse));
  }

  void handleAction(ItemAction action, RoutesModel model) =>
      logE("TAG ACTION: $action");

  void onRefresh() {
    Utils.fireEvent(RefreshEvent(RefreshType.FILTER));
    emit(RoutesPageState(
      status: RouteStatus.refresh,
      keySearch: state.keySearch,
      isLoading: false,
      isReadEnd: false,
    ));
    getRoutes();
  }

  void selectRoutes(int index, bool isSelect) {
    state.lRoutes[index].isSelect = isSelect;
    emit(state.copyWith(
        lRoutes: state.lRoutes,
        timeStamp: DateTime.now().millisecondsSinceEpoch));
  }

  void itemOnclick(BuildContext context, RoutesModel model) async {
    RouterUtils.openNewPage(
        RoutesDetailPage(
            index: BottomNavigationConstant.TAB_ROUTES, model: model),
        context);
  }

  void selectOnclick(bool isShowAdd) async {
    for (int i = 0; i < state.lRoutes.length; i++) {
      state.lRoutes[i].isSelect = false;
    }
    emit(state.copyWith(
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        isShowAdd: isShowAdd,
        isShowActionButton: false));
  }

  void itemOnDoubleClick(
      BuildContext context, int index, FilterController controller,
      {bool isMultiSelect = false, RoutesModel? model}) {
    Utils.hideKeyboard(context);
    var isAddToPlaylist = false;
    var countNotAddToPlaylist = 0;
    for (var element in state.lRoutes) {
      if (element.isSelect) {
        if (element.playlistIn == true || element.favouriteIn == true) {
          isAddToPlaylist = true;
        } else {
          countNotAddToPlaylist++;
        }
      }
    }
    Utils.showActionDialog(context, (type) {
      Navigator.pop(context);
      switch (type) {
        case ItemAction.ADD_TO_PLAYLIST:
          addToPlaylist(context, controller,
              model: model, isMultiSelect: isMultiSelect);
          return;
        case ItemAction.REMOVE_FROM_PLAYLIST:
          removeFromPlaylist(context, controller, index,
              model: model, isMultiSelect: isMultiSelect);
          return;
        case ItemAction.ADD_TO_FAVOURITE:
          addToFav(context, controller,
              model: model, isMultiSelect: isMultiSelect);
          return;
        case ItemAction.REMOVE_FROM_FAVORITE:
          removeFromFavourite(context, index, controller,
              model: model, isMultiSelect: isMultiSelect);
          return;
      }
    },
        checkPlaylists:
            (!isAddToPlaylist || (isAddToPlaylist && countNotAddToPlaylist > 0))
                ? true
                : false,
        isSearchRoute: true,
        model: model);
  }

  void none() {}

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      FilterRoutesPage(
        keySearch: state.keySearch,
        listRoute: state.lRoutes,
        filter: state.filter,
        type: FilterType.SearchRoute,
        showResultButton: (model) {
          emit(state.copyWith(
              nextPage: 0,
              keySearch: state.keySearch,
              typeSearchRoute: SearchRouteType.Filter,
              filter: model,
              isLoading: false,
              isReadEnd: false,
              lRoutes: []));
          Utils.hideKeyboard(context);
          getRoutes();
        },
        removeFilterCallBack: (model) {
          state.filter = model;
        },
      ),
      context);

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

  void sortOnclick(BuildContext context) {
    Utils.showSortDialog(context, (type) async {
      Navigator.pop(context);
      state.sort = type;
      state.typeSearchRoute = SearchRouteType.Sort;
      emit(
        state.copyWith(
            keySearch: state.keySearch,
            sort: type,
            typeSearchRoute: SearchRouteType.Sort,
            isLoading: false,
            isReadEnd: false),
      );
      Utils.hideKeyboard(context);
      getRoutes();
    }, state.sort);
  }

  void setKeySearch(String keySearch) {
    emit(RoutesPageState(keySearch: keySearch, nextPage: 0));
    search(keySearch, 0);
  }

  void search(String keySearch, int nextPage, {bool isPaging = false}) async {
    nextPage;
    if ((keySearch.isEmpty && state.typeSearchRoute == SearchRouteType.Sort) ||
        keySearch.isEmpty && state.filter == null && state.sort == null) {
      emit(RoutesPageState(
          isLoading: false, isReadEnd: false, status: RouteStatus.success));
      return;
    }
    emit(state.copyWith(
        status: isPaging ? RouteStatus.success : RouteStatus.search,
        isLoading: true));
    try {
      var response = await userRepository.searchRoute(
        value: keySearch,
        nextPage: nextPage,
        type: state.typeSearchRoute,
        orderType: state.sort?.orderType,
        orderValue: state.sort?.orderValue,
        status: state.filter?.status != null && state.filter!.status.isNotEmpty
            ? state.filter?.status[0][state.filter?.status[0].keys.first]
            : null,
        authorGradeFrom: state.filter?.authorGradeFrom,
        authorGradeTo: state.filter?.authorGradeTo,
        userGradeFrom: state.filter?.userGradeFrom,
        userGradeTo: state.filter?.userGradeTo,
        hasConner:
            state.filter?.corner != null && state.filter!.corner.isNotEmpty
                ? state.filter?.corner[0][state.filter?.corner[0].keys.first]
                : null,
        setter: state.filter?.designBy != null &&
                state.filter!.designBy.isNotEmpty
            ? state.filter?.designBy[0][state.filter?.designBy[0].keys.first]
            : null,
      );
      var lResponse = routeModelBySearchFromJson(response.data);
      if (response.data != null && response.error == null) {
        emit(state.copyWith(
            keySearch: keySearch,
            status: RouteStatus.success,
            isReadEnd: lResponse.isEmpty,
            lRoutes: isPaging ? (state.lRoutes..addAll(lResponse)) : lResponse,
            isLoading: false,
            nextPage: nextPage + 1));
      } else {
        emit(state.copyWith(
            isReadEnd: true, isLoading: false, status: RouteStatus.failure));
        toast(response.error.toString());
      }
    } catch (ex) {
      emit(state.copyWith(
          status: state.lRoutes.isNotEmpty
              ? RouteStatus.success
              : RouteStatus.failure,
          isReadEnd: true,
          isLoading: false));
    }
  }

  void addToPlaylist(BuildContext context, FilterController controller,
      {RoutesModel? model,
      bool isMultiSelect = false,
      bool isAdd = false}) async {
    Dialogs.showLoadingDialog(context);
    var lRoutes = <String>[];
    var lIndex = [];
    if (isMultiSelect) {
      for (int i = 0; i < state.lRoutes.length; i++) {
        if (state.lRoutes[i].isSelect) {
          lRoutes.add(state.lRoutes[i].id ?? '');
          lIndex.add(i);
        }
      }
    } else {
      lRoutes.add(model!.id ?? "");
    }
    var response =
        await userRepository.addToPlaylist(globals.playlistId, lRoutes);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      for (int i = 0; i < lIndex.length; i++) {
        state.lRoutes[lIndex[i]].playlistIn = true;
        state.lRoutes[lIndex[i]].isSelect = false;
      }
      toast(response.message);
      model?.playlistIn = true;
      emit(state.copyWith(
          timeStamp: DateTime.now().microsecondsSinceEpoch,
          isShowAdd: true,
          isShowActionButton: false));
      controller.setSelect = false;
      Utils.fireEvent(RefreshEvent(RefreshType.PLAYLIST));
    } else {
      toast(response.error.toString());
    }
  }

  void removeFromPlaylist(
    BuildContext context,
    FilterController controller,
    int index, {
    RoutesModel? model,
    bool isMultiSelect = false,
  }) async {
    var lRoutes = "";
    var lIndex = [];
    if (isMultiSelect) {
      for (int i = 0; i < state.lRoutes.length; i++) {
        if (state.lRoutes[i].isSelect) {
          lRoutes += (state.lRoutes[i].id ?? '') + ",";
          lIndex.add(i);
        }
      }
    } else {
      lRoutes = model?.id ?? "";
    }
    Dialogs.showLoadingDialog(context);
    var response =
        await userRepository.removeFromPlaylist(globals.playlistId, lRoutes);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      if (isMultiSelect) {
        toast(response.message);
        emit(
          state.copyWith(
              timeStamp: DateTime.now().microsecondsSinceEpoch,
              isShowAdd: true,
              isShowActionButton: false),
        );
      } else {
        toast(response.message);
        model?.playlistIn = false;
        emit(state.copyWith(
            timeStamp: DateTime.now().microsecondsSinceEpoch,
            isShowAdd: true,
            isShowActionButton: false));
      }
      Utils.fireEvent(RefreshEvent(RefreshType.PLAYLIST));
      controller.setSelect = false;
    } else {
      toast(response.error.toString());
    }
  }

  void addToFav(
    BuildContext context,
    FilterController controller, {
    RoutesModel? model,
    bool isMultiSelect = false,
  }) async {
    Dialogs.showLoadingDialog(context);
    var lRoutes = <String>[];
    var lIndex = [];
    if (isMultiSelect) {
      for (int i = 0; i < state.lRoutes.length; i++) {
        if (state.lRoutes[i].isSelect) {
          lRoutes.add(state.lRoutes[i].id ?? '');
          lIndex.add(i);
        }
      }
    } else {
      lRoutes.add(model?.id ?? "");
    }
    var response = await userRepository.addToFavorite(globals.userId, lRoutes);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      for (int i = 0; i < lIndex.length; i++) {
        state.lRoutes[lIndex[i]].favouriteIn = true;
        state.lRoutes[lIndex[i]].isSelect = false;
      }
      toast(response.message);
      model?.favouriteIn = true;
      emit(state.copyWith(
          timeStamp: DateTime.now().microsecondsSinceEpoch,
          isShowAdd: true,
          isShowActionButton: false));
      Utils.fireEvent(RefreshEvent(RefreshType.FAVORITE));
      controller.setSelect = false;
    } else {
      toast(response.error.toString());
    }
  }

  void removeFromFavourite(
      BuildContext context, int index, FilterController controller,
      {RoutesModel? model, bool isMultiSelect = false}) async {
    Dialogs.showLoadingDialog(context);
    var routeIds = '';
    var lIndex = [];
    if (isMultiSelect) {
      for (int i = 0; i < state.lRoutes.length; i++) {
        if (state.lRoutes[i].isSelect) {
          routeIds += (state.lRoutes[i].id ?? '') + ",";
          lIndex.add(i);
        }
      }
    } else {
      routeIds = model?.id ?? '';
    }
    var response = await userRepository.removeFromFavorite(routeIds);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      if (isMultiSelect) {
        toast(response.message);
        emit(
          state.copyWith(
              timeStamp: DateTime.now().microsecondsSinceEpoch,
              isShowAdd: true,
              isShowActionButton: false),
        );
      } else {
        toast(response.message);
        model?.favouriteIn =false;
        emit(state.copyWith(
            timeStamp: DateTime.now().microsecondsSinceEpoch,
            isShowAdd: true,
            isShowActionButton: false));
      }
      Utils.fireEvent(RefreshEvent(RefreshType.FAVORITE));
      controller.setSelect = false;
    } else {
      toast(response.error.toString());
    }
  }
}
