import 'package:equatable/equatable.dart';

class TabGoodsState extends Equatable {
  final bool isBluetooth;
  final bool isGps;
  final int? timeStamp;

  const TabGoodsState({
    this.isBluetooth = false,
    this.isGps = false,
    this.timeStamp,
  });

  TabGoodsState copyOf({bool? isBluetooth, bool? isGps}) => TabGoodsState(
      isBluetooth: isBluetooth ?? this.isBluetooth,
      isGps: isGps ?? this.isGps,
      timeStamp: timeStamp ?? timeStamp);

  @override
  List<Object?> get props => [isBluetooth, isGps, timeStamp];
}
