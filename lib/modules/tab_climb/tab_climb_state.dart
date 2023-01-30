import 'package:equatable/equatable.dart';

import '../../data/model/wall_model.dart';

class TabClimbState extends Equatable {
  final bool isBluetooth;
  final bool isGps;
  final int? timeStamp;

  const TabClimbState({
    this.isBluetooth = false,
    this.isGps = false,
    this.timeStamp,
  });

  TabClimbState copyOf({bool? isBluetooth, bool? isGps}) => TabClimbState(
      isBluetooth: isBluetooth ?? this.isBluetooth,
      isGps: isGps ?? this.isGps,
      timeStamp: timeStamp ?? timeStamp,
     );

  @override
  List<Object?> get props => [isBluetooth, isGps, timeStamp,];
}
