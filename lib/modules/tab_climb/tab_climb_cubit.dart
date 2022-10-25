import 'package:base_bloc/modules/tab_climb/tab_climb_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/constant.dart';
import '../../data/model/list_places_model.dart';
import '../../router/router_utils.dart';

class TabClimbCubit extends Cubit<TabClimbState> {
  TabClimbCubit() : super(const TabClimbState()) {
    iosGetBlueState(const Duration(seconds: 0));
    androidGetBlueLack(const Duration(seconds: 0));
  }

  void iosGetBlueState(timer) {
    FlutterBlueElves.instance.iosCheckBluetoothState().then((value) => emit(
        state.copyOf(
            isBluetooth: value == IosBluetoothState.poweredOn ? true : false)));
  }

  void androidGetBlueLack(timer) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((values) async {
      if (values.contains(AndroidBluetoothLack.bluetoothFunction)) {
        emit(state.copyOf(isBluetooth: false));
      } else {
        emit(state.copyOf(isBluetooth: true));
        var isGps = await checkTurnOnGps();
        emit(state.copyOf(isGps: isGps));
      }
    });
  }

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushClimb(
        context: context,
        route: ClimbRouters.login,
        argument: BottomNavigationConstant.TAB_CLIMB);
    emit(TabClimbState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }
}

Future<bool> checkTurnOnGps() async =>
    await Geolocator.isLocationServiceEnabled();


List<PlacesModel> fakeData() => [
      PlacesModel(
          namePlace: 'Murall',
          nameCity: 'Warsaw',
          distance: 2.2,
          lat: 21.0484124195535,
          lng: 105.80959985686454),
      PlacesModel(
          namePlace: 'Makak',
          nameCity: 'Warsaw',
          distance: 2.2,
          lat: 21.061288097479334,
          lng: 105.80934959954087),
      PlacesModel(
          namePlace: 'Murall',
          nameCity: 'Warsaw',
          distance: 2.2,
          lat: 21.079085115322442,
          lng: 105.8124170251354),
    ];
