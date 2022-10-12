import 'dart:async';

import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/modules/create_routes/create_routes_page.dart';
import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/routes_model.dart';
import '../routers_detail/routes_detail_page.dart';

enum ItemAction {
  MOVE_TO_TOP,
  ADD_TO_PLAYLIST,
  REMOVE_FROM_PLAYLIST,
  ADD_TO_FAVOURITE,
  SHARE,
  COPY,
  EDIT,
  DELETE
}

class PlayListCubit extends Cubit<PlaylistState> {
  PlayListCubit() : super(const PlaylistState()) {
    if (state.status == FeedStatus.initial) {
      getPlaylist();
    }
  }

  onRefresh() {
    emit(const PlaylistState(status: FeedStatus.refresh));
    getPlaylist();
  }

  getPlaylist({bool isPaging = false}) {
    if (state.isReadEnd) return;
    if (isPaging) {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true));
      Timer(
          const Duration(milliseconds: 200),
          () => emit(state.copyWith(
              isReadEnd: false,
              status: FeedStatus.success,
              lPlayList: state.lPlayList..addAll(fakeData()),
              isLoading: false)));
    } else {
      Timer(
          const Duration(milliseconds: 200),
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

  void itemOnLongClick(BuildContext context) =>
      Utils.showActionDialog(context, (p0) {});

  void itemOnclick(BuildContext context, RoutesModel model) =>
      RouterUtils.openNewPage(
          RoutesDetailPage(
            index: BottomNavigationConstant.TAB_ROUTES,
            model: model,
          ),
          context);

  void createRoutesOnClick(BuildContext context) =>
      RouterUtils.openNewPage(CreateRoutesPage(), context);

  List<RoutesModel> fakeData() => [
        RoutesModel(
            name: 'Adam 2022-05-22',
            height: 12,
            author: 'Adam Kowasaki',
            grade: '8A',
            status: 'corner'),
        RoutesModel(
          name: 'Adam 2022-05-22',
          height: 122,
          author: 'TSU Tokoda',
          grade: '7B',
        ),
        RoutesModel(
          name: 'Adam 2022-05-22',
          height: 11,
          author: 'AI Kowasaki',
          grade: '6A',
        ),
        RoutesModel(
          name: 'Adam 2022-05-22',
          height: 12,
          author: 'Adam Kowasaki',
          grade: '6A',
        ),
        RoutesModel(
            name: 'Adam 2022-05-22',
            height: 122,
            author: 'TSU Tokoda',
            grade: '5B',
            status: 'corner'),
        RoutesModel(
            name: 'Adam 2022-05-22',
            height: 11,
            author: 'AI Kowasaki',
            grade: '6A',
            status: 'corner'),
        RoutesModel(
            name: 'Adam 2022-05-22',
            height: 11,
            author: 'AI Kowasaki',
            grade: '6A',
            status: 'corner')
      ];
}
