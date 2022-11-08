import 'dart:async';
import 'package:base_bloc/modules/routes_page/routes_page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../data/eventbus/refresh_event.dart';
import '../../data/model/routes_model.dart';
import '../../localizations/app_localazations.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../../utils/toast_utils.dart';
import '../filter_routes/filter_routes_page.dart';
import '../playlist/playlist_cubit.dart';
import '../routers_detail/routes_detail_page.dart';
import '../tab_home/tab_home_state.dart';


class RoutesPageCubit extends Cubit<RoutesPageState> {
  RoutesPageCubit() : super(const RoutesPageState()) {
    if (state.status == DesignStatus.initial) {
      getRoutes();
    }
  }

  onRefresh() {
    emit(const RoutesPageState(status: DesignStatus.refresh));
    getRoutes();
  }

  getRoutes({bool isPaging = false}) {
    if (state.isReadEnd) return;
    if (isPaging) {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true));
      Timer(
          const Duration(seconds: 1),
              () => emit(state.copyWith(
              isReadEnd: false,
              status: DesignStatus.success,
              lRoutes: state.lRoutes..addAll(fakeData()),
              isLoading: false)));
    } else {
      Timer(
          const Duration(seconds: 1),
              () => emit(state.copyWith(
              status: DesignStatus.success,
              lRoutes: fakeData(),
              isLoading: false)));
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

  void refresh() {
    Utils.fireEvent(RefreshEvent(RefreshType.FILTER));
    emit(
       const RoutesPageState(status: DesignStatus.refresh),
    );
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

  List<RoutesModel> fakeData() => [
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 12,
       ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 122,

    ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 11,

    ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 12,

    ),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 122,
      ),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 11,
   ),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 11,
       )
  ];

  void selectOnclick(bool isShowAdd) async{
    for(int i =0;i<state.lRoutes.length;i++){
      state.lRoutes[i].isSelect = false;
    }
    emit(state.copyWith(timeStamp: DateTime.now().millisecondsSinceEpoch,isShowAdd: isShowAdd,isShowActionButton: false));
  }

  void itemOnLongPress(BuildContext context) =>
      Utils.showActionDialog(context, (p0) {});

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      const FilterRoutesPage(),
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
    logE("TAG IS SHOW BUTON: ${isShowActionButton}");
    emit(state.copyWith(
        isShowActionButton: isShowActionButton,
        lRoutes: state.lRoutes,
        timeStamp: DateTime.now().millisecondsSinceEpoch));
}

  void search(String keySearch) {
    if (keySearch.isEmpty) {
      emit(state.copyWith(status: DesignStatus.success));
    } else {
      emit(state.copyWith(status: DesignStatus.search));
    }
  }
}