import 'dart:async';
import 'dart:math';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/app_database.dart';
import 'package:base_bloc/modules/places_page/places_page_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/places_model.dart';
import '../place_address/place_address.dart';
import '../tab_home/tab_home_state.dart';

class PlacesPageCubit extends Cubit<PlacesPageState> {
  int index;

  PlacesPageCubit(this.index) : super(const PlacesPageState()) {
    if (state.status == FeedStatus.initial) {
      getPlacesPage();
      getLastSearch();
    }
  }

  void clearCache() async {
    await AppDatabase.instance.removeAllData();
    emit(state.copyWith(lLastPlace: []));
  }

  onRefresh() {
    emit(const PlacesPageState(status: FeedStatus.refresh));
    getPlacesPage();
    getLastSearch();
  }

  getLastSearch() async {
    var lLastPlace = await AppDatabase.instance.readAllPlace();
    emit(state.copyWith(lLastPlace: lLastPlace));
  }

  getPlacesPage({bool isPaging = false}) {
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

  void placeOnClick(PlacesModel model, BuildContext context) async {
    await AppDatabase.instance.create(model);
    getLastSearch();
    switch (index) {
      case BottomNavigationConstant.TAB_HOME:
        RouterUtils.pushHome(
            context: context, argument: [index,model], route: HomeRouters.placeDetail);
        break;
      case BottomNavigationConstant.TAB_ROUTES:
        RouterUtils.pushRoutes(
            context: context,
            route: RoutesRouters.placeDetail,
            argument: [index,model]);
        break;
      case BottomNavigationConstant.TAB_CLIMB:
        RouterUtils.pushClimb(
            context: context, route: ClimbRouters.placeDetail, argument: [index,model]);
        break;
      case BottomNavigationConstant.TAB_RESERVATIONS:
        RouterUtils.pushReservations(
            context: context,
            route: ReservationRouters.placeDetail,
            argument: [index,model]);
        break;
      case BottomNavigationConstant.TAB_PROFILE:
        RouterUtils.pushProfile(
            context: context,
            route: ProfileRouters.placeDetail,
            argument: [index,model]);
        break;
    }
  }

  List<PlacesModel> fakeData() => [
        PlacesModel(
            namePlace: 'Hardwalls',
            nameCity: 'Warsaw',
            distance: 2.2,
            lat: 21.0484124195535,
            lng: 105.80959985686454),
        PlacesModel(
            namePlace: 'AAAAAA',
            nameCity: 'aaa',
            distance: 3.2,
            lat: 21.061288097479334,
            lng: 105.80934959954087),
        PlacesModel(
            namePlace: 'BBBBBB',
            nameCity: 'bbb',
            distance: 4.2,
            lat: 21.079085115322442,
            lng: 105.8124170251354),
        PlacesModel(
          namePlace: 'CCCCC',
          nameCity: 'ccc',
          distance: 4.2,
          lat: 21.04402607922795,
          lng: 105.83373275717862,
        ),
        PlacesModel(
          namePlace: 'DDDDD',
          nameCity: 'ddd',
          distance: 4.2,
          lat: 21.042763054966294,
          lng: 105.8248191801123,
        ),
        PlacesModel(
            namePlace: 'EEEE',
            nameCity: 'eee',
            distance: 4.2,
            lat: 21.037624617195576,
            lng: 105.8198666674366)
      ];
}
