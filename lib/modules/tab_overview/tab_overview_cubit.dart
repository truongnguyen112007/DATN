import 'dart:async';
import 'package:base_bloc/data/model/calender_param.dart';
import 'package:base_bloc/modules/tab_overview/tab_overview_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../config/constant.dart';
import '../../data/model/feed_model.dart';
import '../../gen/assets.gen.dart';
import '../../router/router.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';

class TabOverViewCubit extends Cubit<TabOverViewState> {
  TabOverViewCubit() : super( TabOverViewState(status: FeedStatus.initial,calender: CalenderParam(name: "Hôm nay"))) {
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
        emit(TabOverViewState(
            readEnd: false,
            lFeed: fakeData(),
            status: FeedStatus.success,
            currentPage: 1));
      });
    }
  }

  void refresh() {
    emit( TabOverViewState(status: FeedStatus.refresh));
    getFeed();
  }

  void onClickSearch(BuildContext context) => RouterUtils.pushOverView(
      context: context,
      route: OverViewRouters.search,
      argument: BottomNavigationConstant.TAB_OVERVIEW);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushOverView(
        context: context,
        route: OverViewRouters.login,
        argument: BottomNavigationConstant.TAB_OVERVIEW);
    emit(state.copyOf(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void onClickNotification(BuildContext context) => /*toast(LocaleKeys.thisFeatureIsUnder);*/
      RouterUtils.pushOverView(
      context: context,
      route: OverViewRouters.notifications,
      argument: BottomNavigationConstant.TAB_OVERVIEW);

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

  void onClickCalender (BuildContext context) {
    Utils.showCalenderDialog(context, (type) async {
      Navigator.of(context).pop();
      // logE(type.name.toString());
      emit(state.copyOf(
          calender: type,
      ));
    }, state.calender);
  }
}
