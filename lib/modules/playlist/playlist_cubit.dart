import 'dart:async';

import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/playlist_model.dart';

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

  List<PlayListModel> fakeData() => [
        PlayListModel(
            name: 'Adam 2022-05-22',
            height: 12,
            author: 'Adam Kowasaki',
            grade: '8A',
            status: 'corner'),
        PlayListModel(
          name: 'Adam 2022-05-22',
          height: 122,
          author: 'TSU Tokoda',
          grade: '7B',
        ),
        PlayListModel(
          name: 'Adam 2022-05-22',
          height: 11,
          author: 'AI Kowasaki',
          grade: '6A',
        ),
        PlayListModel(
          name: 'Adam 2022-05-22',
          height: 12,
          author: 'Adam Kowasaki',
          grade: '6A',
        ),
        PlayListModel(
            name: 'Adam 2022-05-22',
            height: 122,
            author: 'TSU Tokoda',
            grade: '5B',
            status: 'corner'),
        PlayListModel(
            name: 'Adam 2022-05-22',
            height: 11,
            author: 'AI Kowasaki',
            grade: '6A',
            status: 'corner'),
        PlayListModel(
            name: 'Adam 2022-05-22',
            height: 11,
            author: 'AI Kowasaki',
            grade: '6A',
            status: 'corner')
      ];
}
