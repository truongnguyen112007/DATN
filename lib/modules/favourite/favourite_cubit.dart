import 'dart:async';

import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/eventbus/refresh_event.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/favourite/favourite_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/routes_model.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../create_routes/create_routes_page.dart';
import '../filter_routes/filter_routes_page.dart';
import '../playlist/playlist_cubit.dart';
import '../routers_detail/routes_detail_page.dart';
import '../tab_home/tab_home_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(const FavouriteState()) {
    if (state.status == FeedStatus.initial) {
      getFavourite();
    }
  }

  onRefresh() {
    emit(const FavouriteState(status: FeedStatus.refresh));
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
              status: FeedStatus.success,
              lPlayList: state.lPlayList..addAll(fakeData()),
              isLoading: false)));
    } else {
      Timer(
          const Duration(seconds: 1),
          () => emit(state.copyWith(
              status: FeedStatus.success,
              lPlayList: fakeData(),
              isLoading: false)));
    }
  }

  setIndex(int newIndex, int oldIndex) {
    var lResponse = state.lPlayList;
    var newItem = lResponse.removeAt(oldIndex);
    lResponse.insert(newIndex, newItem);
    emit(state.copyWith(lPlayList: lResponse));
  }

  void handleAction(ItemAction action, RoutesModel model) =>
      logE("TAG ACTION: $action");

  void refresh() {
    Utils.fireEvent(RefreshEvent(RefreshType.FILTER));
    emit(
      const FavouriteState(status: FeedStatus.refresh),
    );
    getFavourite();
  }

  void createRoutesOnClick(BuildContext context) => /*toast(LocaleKeys.thisFeatureIsUnder)*/
      RouterUtils.openNewPage(const CreateRoutesPage(), context);

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
            height: 11),
        RoutesModel(
            name: 'Adam 2022-05-22',
            height: 11,
           )
      ];

  void itemOnLongPress(BuildContext context) =>
      Utils.showActionDialog(context, (p0) {});

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      const FilterRoutesPage(),
      context);

  void selectOnclick(bool isShowAdd) async{
    for(int i =0;i<state.lPlayList.length;i++){
      state.lPlayList[i].isSelect = false;
    }
    emit(state.copyWith(timeStamp: DateTime.now().millisecondsSinceEpoch,isShowAdd: isShowAdd,isShowActionButton: false));
  }

  void itemOnclick(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
            index: BottomNavigationConstant.TAB_ROUTES,
            model: model,
          ),
          context);

  void filterItemOnclick(int index) {
    state.lPlayList[index].isSelect = !state.lPlayList[index].isSelect;
    var isShowActionButton = false;
    for (int i = 0; i < state.lPlayList.length; i++) {
      if (state.lPlayList[i].isSelect == true) {
        isShowActionButton = true;
        break;
      }
    }
    logE("TAG IS SHOW BUTON: ${isShowActionButton}");
    emit(state.copyWith(
        isShowActionButton: isShowActionButton,
        lPlayList: state.lPlayList,
        timeStamp: DateTime.now().millisecondsSinceEpoch));
    var isFilter = false;
    /*  for (int i = 0; i < state.lPlayList.length; i++) {
      logE("TAG INDEX: $i IS SHOW BUTON: ${state.lPlayList[i].isSelect}");
     */ /* if (state.lPlayList[i].isSelect == true) {
        logE("TAG IS SHOW BUTON: TRUE");
        isFilter = true;
        break;
      }*/ /*
    }
    emit(state.copyWith(isShowActionButton: isFilter,timeStamp: DateTime.now().microsecondsSinceEpoch));
  */
  }
}
