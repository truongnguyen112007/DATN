import 'package:base_bloc/modules/tab_overview/tab_overview_state.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/goods_model.dart';

class TabGoodsState extends Equatable {
  final bool isBluetooth;
  final bool isGps;
  final int? timeStamp;
  final List<ProductModel> lProduct;
  final FeedStatus status;

  const TabGoodsState({
    this.isBluetooth = false,
    this.status = FeedStatus.initial,
    this.isGps = false,
    this.lProduct = const [],
    this.timeStamp,
  });

  TabGoodsState copyOf(
          {bool? isBluetooth,
          bool? isGps,
          List<ProductModel>? lProduct,
          FeedStatus? status}) =>
      TabGoodsState(
          status: status ?? this.status,
          isBluetooth: isBluetooth ?? this.isBluetooth,
          isGps: isGps ?? this.isGps,
          lProduct: lProduct ?? this.lProduct,
          timeStamp: timeStamp ?? timeStamp);

  @override
  List<Object?> get props => [isBluetooth, isGps, timeStamp, lProduct, status];
}
