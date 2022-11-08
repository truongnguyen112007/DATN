import 'dart:async';
import 'package:base_bloc/modules/routes_page/routes_page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../data/model/routes_model.dart';
import '../../localizations/app_localazations.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../../utils/toast_utils.dart';
import '../filter_routes/filter_routes_page.dart';
import '../playlist/playlist_cubit.dart';


class RoutesPageCubit extends Cubit<RoutesPageState> {
  RoutesPageCubit() : super(const RoutesPageState()) {
    if (state.status == DesignStatus.initial) {
      getFavourite();
    }
  }

  onRefresh() {
    emit(const RoutesPageState(status: DesignStatus.refresh));
    getFavourite();
  }

  getFavourite({bool isPaging = false}) {
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
    emit(const RoutesPageState(status: DesignStatus.refresh, lRoutes: []));
    getFavourite();
  }

  void selectRoutes(int index, bool isSelect) {
    state.lRoutes[index].isSelect = isSelect;
    emit(state.copyWith(
        lRoutes: state.lRoutes,
        timeStamp: DateTime.now().millisecondsSinceEpoch));
  }

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

  void selectOnClick(BuildContext context) {
    var isSelect = state.lRoutes.where((element) {
      return element.isSelect;
    });
    if (isSelect.isEmpty) {
      toast(AppLocalizations.of(context)!.notItemSelect);
      return;
    }
    Utils.showActionDialog(context, (p0) {});
  }

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      const FilterRoutesPage(
        index: BottomNavigationConstant.TAB_HOME,
      ),
      context);

  void search(String keySearch) {
    if (keySearch.isEmpty) {
      emit(state.copyWith(status: DesignStatus.success));
    } else {
      emit(state.copyWith(status: DesignStatus.search));
    }
  }
}