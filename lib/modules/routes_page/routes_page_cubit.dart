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
      emit(state.copyWith(isLoading: true));
      search(state.keySearch, state.nextPage);
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
        isReadEnd: false));
    getRoutes();
  }

  void selectRoutes(int index, bool isSelect) {
    state.lRoutes[index].isSelect = isSelect;
    emit(state.copyWith(
        lRoutes: state.lRoutes,
        timeStamp: DateTime.now().millisecondsSinceEpoch));
  }

  void itemOnclick(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
            index: BottomNavigationConstant.TAB_RECEIPT,
            model: model,
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

  void itemOnLongPress(
      BuildContext context, int index, FilterController controller,
      {bool isMultiSelect = false, RoutesModel? model}) {
    Utils.hideKeyboard(context);
    var isAddToPlaylist = false;
    var countNotAddToPlaylist = 0;
    for (var element in state.lRoutes) {
      if (element.isSelect) {
        if (element.playlistIn == true) {
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
        isSearchRoute: true);
  }

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      FilterRoutesPage(
        filter: state.filter,
        type: FilterType.SearchRoute,
        showResultButton: (model) {
          emit(RoutesPageState(
              typeSearchRoute: SearchRouteType.Filter,
              filter: model,
              isLoading: false));
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
      emit(RoutesPageState(
          sort: type, typeSearchRoute: SearchRouteType.Sort, isLoading: false));
      getRoutes();
      Utils.hideKeyboard(context);
    }, state.sort);
  }

  void search(String keySearch, int nextPage, {bool isPaging = false}) async {

  }

  void addToPlaylist(
    BuildContext context,
    FilterController controller, {
    RoutesModel? model,
    bool isMultiSelect = false,
  }) async {

  }

  void removeFromPlaylist(
    BuildContext context,
    FilterController controller,
    int index, {
    RoutesModel? model,
    bool isMultiSelect = false,
  }) async {

  }

  void addToFav(
    BuildContext context,
    FilterController controller, {
    RoutesModel? model,
    bool isMultiSelect = false,
  }) async {

  }

  void removeFromFavourite(
      BuildContext context, int index, FilterController controller,
      {RoutesModel? model, bool isMultiSelect = false}) async {

  }
}
