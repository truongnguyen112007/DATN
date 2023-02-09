import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/components/filter_widget.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/eventbus/refresh_event.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/modules/favourite/favourite_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/routes_model.dart';
import '../../data/repository/user_repository.dart';
import '../../localization/locale_keys.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../create_routes/create_routes_page.dart';
import '../filter_routes/filter_routes_page.dart';
import '../playlist/playlist_cubit.dart';
import '../routers_detail/routes_detail_page.dart';
import '../tab_overview/tab_overview_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  var userRepository = UserRepository();

  FavouriteCubit() : super(FavouriteState()) {
    if (state.status == FeedStatus.initial) {
      getFavourite();
    }
  }

  onRefresh() {
    emit(FavouriteState(status: FeedStatus.refresh));
    getFavourite();
  }

  void itemOnLongClick(
      BuildContext context, int index, FilterController controller,
      {bool isMultiSelect = false, RoutesModel? model}) {
    var countSelect = 0;
    for (var element in state.lPlayList) {
      if (element.isSelect) countSelect++;
    }
    var isAddToPlaylist =
        false; // Cờ check xem có item nào đã add vào playlist chưa
    var countNotAddToPlaylist = 0; // Check số lượng item chưa add vào Playlist
    for (var element in state.lPlayList) {
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
          addToPlaylist(
            context,
            controller,
            isMultiSelect: isMultiSelect,
            model: model,
          );
          return;
        case ItemAction.REMOVE_FROM_FAVORITE:
          removeFromFavourite(
              context,
              model: model,
              index,
              controller,
              isMultiSelect: isMultiSelect);
          return;
        case ItemAction.SHARE:
          shareRoutes(context, model, index);
          return;
        case ItemAction.COPY:
          copyRoutes(context, model, index);
          return;
      }
    },
        checkPlaylists:
            (!isAddToPlaylist || (isAddToPlaylist && countNotAddToPlaylist > 0))
                ? true
                : false,
        isFavorite: true,
        model: model,
        isCopy: !isMultiSelect ? true : (countSelect == 1 ? true : false));
  }

  void handleAction(ItemAction action, RoutesModel model) =>
      logE("TAG ACTION: $action");

  void refresh() {
    Utils.fireEvent(RefreshEvent(RefreshType.FILTER));
    emit(
      FavouriteState(status: FeedStatus.refresh),
    );
    getFavourite();
  }

  void createRoutesOnClick(BuildContext context) =>
      /*toast(LocaleKeys.thisFeatureIsUnder)*/
      RouterUtils.openNewPage(const CreateRoutesPage(), context);

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      FilterRoutesPage(
        filter: state.filter,
        type: FilterType.Favorite,
        showResultButton: (model) {
          emit(FavouriteState(
            favType: FavType.Filter,
            filter: model,
          ));
          getFavourite();
        },
        removeFilterCallBack: (model) {
          state.filter = model;
        },
      ),
      context);

  void sortOnclick(BuildContext context) {
    Utils.showSortDialog(context, (type) async {
      Navigator.pop(context);
      state.sort = type;
      state.favType = FavType.Sort;
      emit(FavouriteState(sort: type, favType: FavType.Sort));
      getFavourite();
    }, state.sort);
  }

  void selectOnclick(bool isShowAdd) async {
    for (int i = 0; i < state.lPlayList.length; i++) {
      state.lPlayList[i].isSelect = false;
    }
    emit(state.copyWith(
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        isShowAdd: isShowAdd,
        isShowActionButton: false));
  }

  void itemOnclick(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
            index: BottomNavigationConstant.TAB_RECEIPT,
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

  void getFavourite({bool isPaging = false}) async {

  }

  void removeFromFavourite(
      BuildContext context, int index, FilterController controller,
      {RoutesModel? model, bool isMultiSelect = false}) async {

  }

  void addToPlaylist(
    BuildContext context,
    FilterController controller, {
    RoutesModel? model,
    bool isMultiSelect = false,
  }) async {

  }

  void refreshPlaylist() {
    Utils.fireEvent(RefreshEvent(RefreshType.PLAYLIST));
  }

  void shareRoutes(BuildContext context, RoutesModel? model, int index) async {
    // Dialogs.showLoadingDialog(context);
    // await Future.delayed(const Duration(seconds: 1));
    // await Dialogs.hideLoadingDialog();
    // toast('Share post success');
    toast(LocaleKeys.thisFeatureIsUnder.tr());
  }

  void copyRoutes(
    BuildContext context,
    RoutesModel? model,
    int index,
  ) =>
      // RouterUtils.openNewPage(CreateRoutesPage(model: model), context);
      toast(LocaleKeys.thisFeatureIsUnder.tr());
}
