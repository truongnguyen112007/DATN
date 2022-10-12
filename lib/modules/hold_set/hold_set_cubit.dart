import 'package:base_bloc/modules/hold_set/hold_set_state.dart';
import 'package:base_bloc/modules/hold_set_detail/hold_set_detail_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';

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
  final List<String> fakePickAll = [
    Assets.png.climbing1.path,
    Assets.png.climbing2.path,
    Assets.png.climbing3.path,
    Assets.png.climbing4.path,
    Assets.png.climbing5.path,
    Assets.png.climbing1.path,
    Assets.png.climbing2.path,
    Assets.png.climbing3.path,
    Assets.png.climbing4.path,
    Assets.png.climbing5.path,
    Assets.png.climbing4.path,
    Assets.png.climbing5.path
  ];

  final List<String> fakePickFavourite = [
    Assets.png.climbing1.path,
    Assets.png.climbing2.path,
    Assets.png.climbing3.path,
    Assets.png.climbing4.path,
    Assets.png.climbing5.path,
    Assets.png.climbing1.path,
  ];
}
