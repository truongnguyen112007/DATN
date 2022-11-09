import 'dart:async';

import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/model/playlist_model.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/create_routes/create_routes_page.dart';
import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/routes_model.dart';
import '../routers_detail/routes_detail_page.dart';

enum ItemAction {
  MOVE_TO_TOP,
  ADD_TO_PLAYLIST,
  REMOVE_FROM_PLAYLIST,
  ADD_TO_FAVOURITE,
  REMOVE_FROM_FAVOUTITE,
  SHARE,
  COPY,
  EDIT,
  DELETE
}

class PlayListCubit extends Cubit<PlaylistState> {
  var userRepository = UserRepository();

  PlayListCubit() : super(PlaylistState()) {
    if (state.status == FeedStatus.initial) {
      // getPlaylist();
      getPlaylists();
    }
  }

  onRefresh() {
    emit(PlaylistState(status: FeedStatus.refresh));
    // getPlaylist();
    getPlaylists();
  }

  void itemOnLongClick(BuildContext context) =>
      Utils.showActionDialog(context, (p0) {});

  void itemOnclick(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
              index: BottomNavigationConstant.TAB_ROUTES, model: model),
          context);

  void createRoutesOnClick(BuildContext context) =>
      RouterUtils.openNewPage(const CreateRoutesPage(), context);

  void getPlaylists() async {
    var response = await userRepository.getPlaylists();
    if (response.error == null && response.data != null) {
      var lPlayList = playListModelFromJson(response.data);
      state.lPlayList = lPlayList;
      getPlayListById();
    } else {
      toast(response.error.toString());
      emit(state.copyWith(status: FeedStatus.failure));
    }
  }

  void getPlayListById() async {
    var response =
        await userRepository.getPlaylistById(state.lPlayList[0].id ?? '');
    if(response.data!=null && response.error==null){
      var lResponse = routeModelFromJson(response.data['routes']);
      emit(state.copyWith(
          status: FeedStatus.success, isLoading: false, lRoutes: lResponse));
    } else {
      toast(response.error.toString());
    }
  }

  List<RoutesModel> fakeData() => [
        RoutesModel(name: 'Adam 2022-05-22', height: 12),
        RoutesModel(
          name: 'Adam 2022-05-22',
          height: 122,
        ),
        RoutesModel(name: 'Adam 2022-05-22', height: 11),
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
}
