import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/home/home_state.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/playlist_model.dart';

class HomeCubit extends Cubit<HomeState> {
  var userRepository = UserRepository();

  HomeCubit() : super(InitState()) {
    checkPlaylistId();
  }

  void jumpToPage(int index) => emit(IndexChangeState(index));

  void hideBottomBar(bool isHide) => emit(HideBottomNavigationBarState(isHide));

  void checkPlaylistId() async {
    if (globals.isLogin) {
      var playlistId = await StorageUtils.getPlaylistId();
      if (playlistId == null) {
        var response = await userRepository.getPlaylists();
        if (response.error == null && response.data != null) {
          var lPlaylist = playListModelFromJson(response.data);
          globals.playlistId = lPlaylist[0].id ?? '';
          StorageUtils.savePlaylistId(globals.playlistId);
        }
      } else {
        globals.playlistId = playlistId;
      }
    }
  }
}
