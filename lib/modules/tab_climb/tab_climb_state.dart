import 'package:equatable/equatable.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';

 class TabClimbState extends Equatable {
  final bool isBluetooth;
  final bool isGps;

 const TabClimbState({this.isBluetooth = false, this.isGps = false});

  TabClimbState copyOf({bool? isBluetooth, bool? isGps}) =>
      TabClimbState(isBluetooth: isBluetooth ?? this.isBluetooth, isGps: isGps?? this.isGps);

  @override
  List<Object?> get props => [isBluetooth, isGps];
}
