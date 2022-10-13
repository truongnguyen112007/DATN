import 'package:base_bloc/modules/tab_climb/tab_climb_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import '../../data/model/list_places_model.dart';

class TabClimbCubit extends Cubit<TabClimbState> {
  TabClimbCubit() : super(TabClimbInitState());

  void iosGetBlueState(timer) {
    FlutterBlueElves.instance.iosCheckBluetoothState().then((value) =>
        emit(
            BluetoothState(
                // isOnBluetooth:
                value == IosBluetoothState.poweredOn
                ? true
                : false /*,
            DateTime.now().microsecondsSinceEpoch*/
            )));
  }

  void androidGetBlueLack(timer) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((values) {
      if (values.contains(AndroidBluetoothLack.bluetoothFunction)) {
        emit(BluetoothState( false));
      } else {
        emit(BluetoothState( true));
        // check location
        // emit((state as BluetoothState).copyOf(isOnLocation: true));
      }
    });
  }
}
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



