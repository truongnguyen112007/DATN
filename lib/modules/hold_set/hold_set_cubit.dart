import 'package:base_bloc/modules/hold_set/hold_set_state.dart';
import 'package:base_bloc/modules/hold_set_detail/hold_set_detail_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';

class HoldModel {
  final String hold3d;
  final String hold2d;

  HoldModel(this.hold3d, this.hold2d);
}

class HoldSetCubit extends Cubit<HoldSetState> {
  HoldSetCubit() : super(const HoldSetState()) {
    emit(state.copyOf(lHoldSet: fakePickAll));
  }

  void selectOnClick(String icon, BuildContext context) =>
      RouterUtils.pop(context, result: icon, isHideBottomBar: true);

  void setIndex(int index) => emit(state.copyOf(currentIndex: index));

  void setFilter(SelectType type) => emit(state.copyOf(
      currentIndex: 0,
      type: type,
      lHoldSet: type == SelectType.ALL ? fakePickAll : fakePickFavourite));

  void detailOnclick(context) =>
      RouterUtils.openNewPage(HoldSetDetailPage(), context);
  final List<HoldModel> fakePickAll = [
    HoldModel(Assets.png.holdset1.path, Assets.svg.holdset1),
    HoldModel(Assets.png.holdset2.path, Assets.svg.holdset2),
    HoldModel(Assets.png.holdset3.path, Assets.svg.holdset3),
    HoldModel(Assets.png.holdset4.path, Assets.svg.holdset4),
    HoldModel(Assets.png.holdset5.path, Assets.svg.holdset5),
    HoldModel(Assets.png.holdset6.path, Assets.svg.holdset6),
    HoldModel(Assets.png.holdset7.path, Assets.svg.holdset1),
    HoldModel(Assets.png.holdset8.path, Assets.svg.holdset2),
    HoldModel(Assets.png.holdset9.path, Assets.svg.holdset3),
    HoldModel(Assets.png.holdset10.path, Assets.svg.holdset4),
    HoldModel(Assets.png.holdset11.path, Assets.svg.holdset5),
    HoldModel(Assets.png.holdset12.path, Assets.svg.holdset6),
  ];

  final List<HoldModel> fakePickFavourite = [
    HoldModel(Assets.png.holdset1.path, Assets.svg.holdset1),
    HoldModel(Assets.png.holdset2.path, Assets.svg.holdset2),
    HoldModel(Assets.png.holdset3.path, Assets.svg.holdset3),
    HoldModel(Assets.png.holdset4.path, Assets.svg.holdset4),
    HoldModel(Assets.png.holdset5.path, Assets.svg.holdset5),
    HoldModel(Assets.png.holdset6.path, Assets.svg.holdset6),
  ];
}
