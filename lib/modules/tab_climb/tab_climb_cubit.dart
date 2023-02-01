
import 'dart:async';

import 'package:base_bloc/modules/tab_climb/tab_climb_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart' as Settings;

import '../../config/constant.dart';
import '../../data/model/places_model.dart';
import '../../data/model/wall_model.dart';
import '../../router/router_utils.dart';
import '../../utils/permission_utils.dart';
import 'dart:io';
class TabClimbCubit extends Cubit<TabClimbState> {
  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();
  final StreamController<String> eddyEventsController =
      StreamController<String>.broadcast();

  TabClimbCubit()
      : super(TabClimbState(lWall: List<WallModel>.empty(growable: true))) {
    Platform.isAndroid ? androidGetBlueLack(const Duration(seconds: 0)):
    iosGetBlueState(const Duration(seconds: 0));
    // refreshBeacon();
  }

  void iosGetBlueState(timer) {
    FlutterBlueElves.instance.iosCheckBluetoothState().then((value){
      // print("TAG BLUETOOTH: $value");
      emit(
          state.copyOf(
              isBluetooth: value == IosBluetoothState.poweredOn ? true : false));
    });
  }
  bool isBeaconStream = false;
  void androidGetBlueLack(timer) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((values) async {
      if (values.contains(AndroidBluetoothLack.bluetoothFunction)) {
        isBeaconStream = false;
        emit(state.copyOf(isBluetooth: false,lWall: []));
      } else {
        emit(state.copyOf(isBluetooth: true));
        var isLocationPermission = await PermissionUtils.isRequestPermission(Permission.location);
        var isGps = await checkTurnOnGps();
          if (isLocationPermission && isGps && !isBeaconStream) {
          beaconStream();
          isBeaconStream = true;
        }
        emit(state.copyOf(isGps: isGps, lWall: state.isGps ? state.lWall : []));
      }
    });
  }
  void onClickNotification(BuildContext context) =>
      RouterUtils.pushClimb(
      context: context,
      route: ClimbRouters.notifications,
      argument: BottomNavigationConstant.TAB_CLIMB);

  void onClickSearch(BuildContext context) => RouterUtils.pushClimb(
      context: context,
      route: ClimbRouters.search,
      argument: BottomNavigationConstant.TAB_CLIMB);


  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushClimb(
        context: context,
        route: ClimbRouters.login,
        argument: BottomNavigationConstant.TAB_CLIMB);
    emit(TabClimbState(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void onClickItemWallLogin(BuildContext context,WallModel model,String index) {
    RouterUtils.pushClimb(
        context: context,
        route: ClimbRouters.routesLoginToWall,
        argument: [BottomNavigationConstant.TAB_CLIMB ,model,index]);
  }

  void beaconStream() async {
    await BeaconsPlugin.startMonitoring();
    BeaconsPlugin.clearRegions();
    BeaconsPlugin.scanEddyStone();
    BeaconsPlugin.listenToScanEddyStone(eddyEventsController);
    eddyEventsController.stream.listen((data) {
      if (data.contains('.cl')) {
        var deviceId =
            RegExp(r'(?<=//)(.*)(?=.cl)').firstMatch(data)?.group(0).toString();
        for (int i = 0; i < state.lWall.length; i++) {
          if (deviceId == state.lWall[i].deviceId) {
            return;
          }
        }
        if(state.isRefreshBeacon) state.lWall.clear();
        state.lWall.add(WallModel(deviceId ?? ''));
        emit(state.copyOf(isRefreshBeacon: false,
            timeStamp: DateTime.now().microsecondsSinceEpoch));
      }
    });
  }

  void refreshBeacon() {
    Timer.periodic(const Duration(seconds: 20), (timer) {
      beaconStream();
      emit(state.copyOf(isRefreshBeacon: true));
    });
  }

  void checkLocation() async {
    var isLocationPermission = await PermissionUtils.isRequestPermission(
        Permission.location,
        isRequest: true);
    if (!isLocationPermission) return;
    var isGps = await Geolocator.isLocationServiceEnabled();
    if (!isGps) {
    Platform.isAndroid ?  FlutterBlueElves.instance.androidOpenLocationService((isOk) {
        if (isOk) beaconStream();
      }):
    Settings.AppSettings.openWIFISettings();} else {
      beaconStream();
    }
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