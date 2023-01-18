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
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/routes_model.dart';
import '../../router/router.dart';
import '../../utils/storage_utils.dart';
import '../routers_detail/routes_detail_page.dart';

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
    // Utils.fireEvent(RefreshEvent(RefreshType.FILTER));
    emit(
      PlaylistState(status: FeedStatus.refresh),
    );
    getPlayListById();
  }

  void itemDoubleClick(BuildContext context, RoutesModel model, int index) {
    logE("TAGA  state.lRoutes[index].favouriteIn : ${ state.lRoutes[index].favouriteIn }");


      Utils.showActionDialog(context, (type) {
        Navigator.of(context, rootNavigator: true).pop();
        switch (type) {
          case ItemAction.REMOVE_FROM_PLAYLIST:
            removeOrAddToPlaylistRoutes(context, model, index, true);
            return;
          case ItemAction.DELETE:
            removeOrAddToPlaylistRoutes(context, model, index, false);
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
      }, isPlaylist: true, model: model,checkFav: true);
  }
  void searchOnclick(BuildContext context) {
    RouterUtils.pushRoutes(
        context: context,
        route: RoutesRouters.search,
        argument: BottomNavigationConstant.TAB_ROUTES);
  }

  void showOverlay(bool isOverlay) =>
      emit(state.copyWith(isOverlay: isOverlay));

  void removeOrAddToPlaylistRoutes(
    BuildContext context,
    RoutesModel model,
    int index,
    bool isRemove,
  ) async {
    Dialogs.showLoadingDialog(context);
    var response = isRemove
        ? await userRepository.removeFromPlaylist(
            globals.playlistId, model.id ?? '')
        : await userRepository
            .addToPlaylist(globals.playlistId, [model.id ?? '']);
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      state.lRoutes.removeAt(index);
      emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
      Utils.fireEvent(RefreshEvent(RefreshType.FAVORITE));
    } else {
      toast(response.error.toString());
    }
  }

  void addOrRemoveFavorite(
      BuildContext context, RoutesModel model, int index, bool isAdd) async {
    Dialogs.showLoadingDialog(context);
    var response = isAdd
        ? await userRepository.addToFavorite(globals.userId, [model.id ?? ''])
        : await userRepository.removeFromFavorite(model.id ?? '');
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      toast(response.message);
      state.lRoutes[index].favouriteIn = isAdd;
      logE("TAGA  state.lRoutes[index].favouriteIn : ${ state.lRoutes[index].favouriteIn }");
      // isAdd ? (model.favouriteIn = true) : (model.favouriteIn = false);
      logE(model.favouriteIn.toString());
      emit(
        state.copyWith(
          timeStamp: DateTime.now().microsecondsSinceEpoch,
        ),
      );
      refreshFav();
    } else {
      toast(response.error.toString());
    }
  }

  void refreshFav() {
    Utils.fireEvent(RefreshEvent(RefreshType.FAVORITE));
  }

  void moveItemToTop(BuildContext context, RoutesModel model, int index) async {
    Dialogs.showLoadingDialog(context);
    var response =
        await userRepository.moveToTop(globals.playlistId, model.id ?? '');
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      state.lRoutes.removeAt(index);
      state.lRoutes.insert(0, model);
      emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
    } else {
      toast(response.data.toString());
    }
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
              index: BottomNavigationConstant.TAB_ROUTES, model: model),
          context);

  void createRoutesOnClick(BuildContext context) => RouterUtils.openNewPage(
      const CreateInfoRoutePage(isPublish: false), context);

  /*RouterUtils.openNewPage(const CreateRoutesPage(), context);*/

  void findRoutes(BuildContext context) => RouterUtils.pushRoutes(
      context: context,
      route: RoutesRouters.search,
      argument: BottomNavigationConstant.TAB_ROUTES);

  Future<void> checkPlaylistId() async {
    if (globals.isLogin) {
      var playlistId = await StorageUtils.getPlaylistId();
      if (playlistId == null) {
        var response = await userRepository.getPlaylists();
        if (response.error == null && response.data != null) {
          var lPlaylist = playListModelFromJson(response.data);
          globals.playlistId = lPlaylist[0].id ?? '';
          StorageUtils.savePlaylistId(globals.playlistId);
        } else {
          emit(state.copyWith(status: FeedStatus.failure));
        }
      } else {
        globals.playlistId = playlistId;
      }
    }
    getPlayListById();
  }

  void getPlayListById({bool isPaging = false}) async {
    if (state.isLoading && state.lRoutes.isNotEmpty || state.isReadEnd) return;
    emit(state.copyWith(isLoading: true));
    var response = await userRepository.getPlaylistById(globals.playlistId,
        nextPage: state.nextPage);
    try {
      if (response.data != null && response.error == null) {
        var lResponse = routeModelFromJson(response.data['routes']);
        emit(state.copyWith(
            status: FeedStatus.success,
            isReadEnd: lResponse.isEmpty,
            nextPage: state.nextPage + 1,
            isLoading: false,
            lRoutesCache:
                isPaging ? (state.lRoutesCache..addAll(lResponse)) : lResponse,
            lRoutes:
                isPaging ? (state.lRoutes..addAll(lResponse)) : lResponse));
      } else {
        emit(state.copyWith(
            isReadEnd: true, isLoading: false, status: FeedStatus.failure));
        toast(response.error.toString());
      }
    } catch (ex) {
      emit(state.copyWith(
          status: state.lRoutes.isNotEmpty
              ? FeedStatus.success
              : FeedStatus.failure,
          isReadEnd: true,
          isLoading: false));
    }
  }

  void dragItem(
    int oldIndex,
    int newIndex,
  ) {
    if (newIndex > oldIndex) newIndex - 1;
    if (state.startIndex > oldIndex) {
      state.startIndex = oldIndex;
    }
    if (state.startIndex > newIndex) {
      state.startIndex = newIndex;
    }
    if (state.endIndex < newIndex) {
      state.endIndex = newIndex;
    }
    if (state.endIndex < oldIndex) {
      state.endIndex = oldIndex;
    }
    final lCache = <RoutesModel>[];
    lCache.addAll(state.lRoutesCache);
    var model = state.lRoutes.removeAt(oldIndex);
    state.lRoutes.insert(newIndex, model);
    emit(state.copyWith(
        timeStamp: DateTime.now().microsecondsSinceEpoch,
        isChooseDragDrop: true,
        lRoutesCache: lCache,));
  }

  void closeDragDrop() {
    emit(state.copyWith(
        isChooseDragDrop: false, lRoutes: state.lRoutesCache,isDrag: false));
  }

  void saveDragDrop(BuildContext context) async {
    Dialogs.showLoadingDialog(context);
    var lId = <String>[];
    for (int i = state.startIndex; i <= state.endIndex; i++) {
      lId.add(state.lRoutes[i].id ?? "");
    }
    var response = await userRepository.dragAndDrop(
        globals.playlistId,
        state.endIndex == state.lRoutes.length
            ? (state.lRoutes.last.id ?? '')
            : state.lRoutes[state.endIndex].id ?? '',
        lId);
    Dialogs.hideLoadingDialog();
    emit(state.copyWith(
      isChooseDragDrop: false,
      isDrag: false,
      startIndex: 1000000,
      endIndex: 0,
    ));
  }

  void setDrag(bool isDrag) {
    if (isDrag && state.isDrag) return;
    emit(state.copyWith(isDrag: isDrag,isChooseDragDrop: true));
  }
}
