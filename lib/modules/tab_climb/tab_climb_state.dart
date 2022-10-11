import 'package:equatable/equatable.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';

abstract class TabClimbState extends Equatable {}

class TabClimbInitState extends TabClimbState {
  @override
  List<Object?> get props => [];
}

class BluetoothState extends TabClimbState {
  final bool? isOnBluetooth;
  // final bool? isOnLocation;

  BluetoothState(this.isOnBluetooth,
    // this.isOnLocation
);

  // BluetoothState copyOf({bool? isOnBluetooth, bool? isOnLocation}) =>
  //     BluetoothState(
  //         isOnBluetooth: isOnBluetooth ?? this.isOnBluetooth
  //         // isOnLocation: isOnLocation ?? this.isOnLocation
  // );

  @override
  List<Object?> get props => [isOnBluetooth,
    // isOnLocation
  ];
}

