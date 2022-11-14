import 'dart:async';

import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/data/model/playlist_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
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
        }
      }, isPlaylist: true);

  void removeOrDeleteRoutes(
      BuildContext context, RoutesModel model, int index, bool isRemove) async {
    Dialogs.showLoadingDialog(context);
    var response = isRemove
        ? await userRepository.removeFromPlaylist(
            globals.playlistId, model.id ?? '')
        : await userRepository.deleteRoute(model.id ?? '');
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      state.lRoutes.removeAt(index);
      emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
    } else {
      toast(response.error.toString());
    }
  }

  void addOrRemoveFavorite(
      BuildContext context, RoutesModel model, int index, bool isAdd) async {
    Dialogs.showLoadingDialog(context);
    var response = isAdd
        ? await userRepository.addToFavorite(globals.userId, model.id ?? '')
        : await userRepository.removeFromFavorite(
            globals.userId, model.id ?? '');
    await Dialogs.hideLoadingDialog();
    if (response.error == null) {
      toast(response.message);
    } else {
      toast(response.error.toString());
    }
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

  void copyRoutes(BuildContext context, RoutesModel model, int index) =>
      RouterUtils.openNewPage(CreateRoutesPage(model: model), context);

  void itemOnclick(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
              index: BottomNavigationConstant.TAB_ROUTES, model: model),
          context);

  void createRoutesOnClick(BuildContext context) =>
      RouterUtils.openNewPage(const CreateRoutesPage(), context);

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
            lRoutes:
                isPaging ? (state.lRoutes..addAll(lResponse)) : lResponse));
      } else {
        emit(state.copyWith(isReadEnd: true, isLoading: false));
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
}
