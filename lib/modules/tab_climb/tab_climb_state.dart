import 'package:equatable/equatable.dart';

import '../../data/model/wall_model.dart';

class TabClimbState extends Equatable {
  final bool isBluetooth;
  final bool isGps;
  final bool isRefreshBeacon;
  final int? timeStamp;
  final List<WallModel> lWall;

  const TabClimbState({
    this.lWall = const [],
    this.isRefreshBeacon = false,
    this.isBluetooth = false,
    this.isGps = false,
    this.timeStamp,
  });

  TabClimbState copyOf(
          {bool? isRefreshBeacon,bool? isBluetooth, bool? isGps, List<WallModel>? lWall, int? timeStamp}) =>
      TabClimbState(
          isRefreshBeacon: isRefreshBeacon ?? this.isRefreshBeacon,
          isBluetooth: isBluetooth ?? this.isBluetooth,
          isGps: isGps ?? this.isGps,
          timeStamp: timeStamp ?? timeStamp,
          lWall: lWall ?? this.lWall);

  @override
  List<Object?> get props => [isBluetooth, isGps, timeStamp, lWall, isRefreshBeacon];
}
