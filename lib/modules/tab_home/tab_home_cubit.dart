import 'dart:async';

import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/constant.dart';
import '../../data/model/feed_model.dart';
import '../../gen/assets.gen.dart';
import '../../router/router.dart';
import '../../router/router_utils.dart';

class TabHomeCubit extends Cubit<TabHomeState> {
  TabHomeCubit() : super(const TabHomeState(status: FeedStatus.initial)) {
    if (state.status == FeedStatus.initial) {
      getFeed();
    }
  }

  void getFeed({bool isPaging = false}) {
    if (state.readEnd) return;
    if (isPaging) {
      Timer(const Duration(seconds: 1), () {
        emit(state.copyOf(
            lFeed: List.of(state.lFeed)..addAll(fakeData()), readEnd: true));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        emit(TabHomeState(
            readEnd: false,
            lFeed: fakeData(),
            status: FeedStatus.success,
            currentPage: 1));
      });
    }
  }

  void refresh() {
    emit(TabHomeState(status: FeedStatus.refresh));
    getFeed();
  }

  void onClickSearch(BuildContext context) => RouterUtils.pushHome(
      context: context,
      route: HomeRouters.search,
      argument: BottomNavigationConstant.TAB_HOME);

  void onClickPlaylist () {

  }

  void onClickNotification(BuildContext context) => RouterUtils.pushHome(
      context: context,
      route: HomeRouters.notifications,
      argument: BottomNavigationConstant.TAB_HOME);

  List<FeedModel> fakeData() => [
        FeedModel(true,
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
        FeedModel(false, '', photoURL: Assets.png.test.path),
      ];

  Future<void> checkLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }
}
