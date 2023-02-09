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

  }
}
