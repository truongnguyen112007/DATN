import 'dart:async';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_state.dart';
import 'package:base_bloc/modules/routes_page/routes_page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class RoutesPageCubit extends Cubit<RoutesPageState> {
  var userRepository = UserRepository();
  RoutesPageCubit() : super( RoutesPageState()) {
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
    emit(RoutesPageState(status: RouteStatus.refresh,keySearch: state.keySearch,isLoading: false,isReadEnd: false));
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
            index: BottomNavigationConstant.TAB_ROUTES,
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

  void itemOnLongPress(BuildContext context) =>
      Utils.showActionDialog(context, (p0) {});

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      FilterRoutesPage(showResultButton: (model){},), context);

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

  void search(String keySearch, int nextPage, {bool isPaging = false}) async {
    emit(RoutesPageState(status: RouteStatus.search, isLoading: true));
    try {
      var response = await userRepository.searchRoute(keySearch, nextPage);
      var lResponse = routeModelBySearchFromJson(response.data);
      if (response.data != null) {
        emit(state.copyWith(
            keySearch: keySearch,
            status: RouteStatus.success,
            lRoutes: isPaging ? (state.lRoutes..addAll(lResponse)) : lResponse,
            isLoading: false,
            nextPage: nextPage++));
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
          isLoading: true));
    }
  }
}
