import 'dart:async';
import 'dart:math';

import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/eventbus/refresh_event.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/data/model/playlist_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_page.dart';
import 'package:base_bloc/modules/create_routes/create_routes_page.dart';
import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/routes_model.dart';
import '../../utils/storage_utils.dart';
import '../routers_detail/routes_detail_page.dart';
import '../tab_overview/tab_overview_state.dart';

enum ItemAction {
  MOVE_TO_TOP,
  ADD_TO_PLAYLIST,
  REMOVE_FROM_PLAYLIST,
  ADD_TO_FAVOURITE,
  REMOVE_FROM_FAVORITE,
  SHARE,
  COPY,
  EDIT,
  DELETE
}


class PlayListCubit extends Cubit<PlaylistState> {
  var userRepository = UserRepository();

  PlayListCubit() : super(PlaylistState()) {
    checkPlaylistId();
  }

  onRefresh() {
    emit(PlaylistState(status: FeedStatus.refresh));
    getPlayListById();
  }

  void itemOnLongClick(BuildContext context, RoutesModel model, int index) =>
      Utils.showActionDialog(context, (type) {
        Navigator.pop(context);
        switch (type) {
          case ItemAction.REMOVE_FROM_PLAYLIST:
            removeOrDeleteRoutes(context, model, index, true);
            return;
          case ItemAction.DELETE:
            removeOrDeleteRoutes(context, model, index, false);
            return;
          case ItemAction.ADD_TO_FAVOURITE:
            addOrRemoveFavorite(context, model, index, true);
            return;
          case ItemAction.REMOVE_FROM_FAVORITE:
            addOrRemoveFavorite(context, model, index, false);
            return;
          case ItemAction.MOVE_TO_TOP:
            moveItemToTop(context, model, index);
            return;
          case ItemAction.SHARE:
            shareRoutes(context, model, index);
            return;
          case ItemAction.COPY:
            copyRoutes(context, model, index);
            return;
          case ItemAction.EDIT:
            editRoute(context, model, index);
            return;
        }
      }, isPlaylist: true, model: model);

  void removeOrDeleteRoutes(
    BuildContext context,
    RoutesModel model,
    int index,
    bool isRemove,
  ) async {

  }

  void addOrRemoveFavorite(
      BuildContext context, RoutesModel model, int index, bool isAdd) async {
    Dialogs.showLoadingDialog(context);

  }

  void refreshFav() {
    Utils.fireEvent(RefreshEvent(RefreshType.FAVORITE));
  }

  void moveItemToTop(BuildContext context, RoutesModel model, int index) async {
    Dialogs.showLoadingDialog(context);

  }

  void shareRoutes(BuildContext context, RoutesModel model, int index) async {
    Dialogs.showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 1));
    await Dialogs.hideLoadingDialog();
    toast('Share post success');
  }

  void editRoute(BuildContext context, RoutesModel model, int index) =>
      RouterUtils.openNewPage(
          CreateRoutesPage(model: model, isEdit: true), context);

  void copyRoutes(BuildContext context, RoutesModel model, int index) =>
      RouterUtils.openNewPage(CreateRoutesPage(model: model), context);

  void itemOnclick(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
              index: BottomNavigationConstant.TAB_RECEIPT, model: model),
          context);

  void createRoutesOnClick(BuildContext context) =>
      RouterUtils.openNewPage(const CreateInfoRoutePage(isPublish: false), context);
  /*RouterUtils.openNewPage(const CreateRoutesPage(), context);*/

  Future<void> checkPlaylistId() async {

  }

  void getPlayListById({bool isPaging = false}) async {

  }
}
