import 'dart:async';

import 'package:base_bloc/modules/find_place/find_place_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/model/list_places_model.dart';

class FindPlaceCubit extends Cubit<FindPlaceState> {
  FindPlaceCubit() : super(const FindPlaceState()) {
    if (state.status == FindPlaceStatus.initial) {
      getPlace();
    }
  }

  void search(String keyWord) {
    emit(state.copyWith(status: FindPlaceStatus.search));
    getPlace();
  }

  void showMap() => emit(state.copyWith(isShowMap: !state.isShowMap));

  onRefresh() {
    emit(const FindPlaceState(status: FindPlaceStatus.refresh));
    getPlace();
  }

  void itemOnclick(PlacesModel model, BuildContext context) =>
      RouterUtils.pop(context, result: model);

  void mapCallback(LatLng lng, BuildContext context) =>
      RouterUtils.pop(context, result: state.lPlayList[0]);

  getPlace({bool isPaging = false}) {
    if (state.isReadEnd) return;
    if (isPaging) {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true));
      Timer(
          const Duration(seconds: 1),
          () => emit(state.copyWith(
              isReadEnd: false,
              status: FindPlaceStatus.success,
              lPlayList: state.lPlayList..addAll(fakeData()),
              isLoading: false)));
    } else {
      Timer(
          const Duration(seconds: 1),
          () => emit(state.copyWith(
              status: FindPlaceStatus.success,
              lPlayList: fakeData(),
              isLoading: false)));
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
            lng: 105.8198666674366),
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
            lng: 105.8198666674366),
      ];
}
