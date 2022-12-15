import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/hold_set/hold_set_state.dart';
import 'package:base_bloc/modules/hold_set_detail/hold_set_detail_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/hold_set_model.dart';
import '../../gen/assets.gen.dart';


class HoldSetCubit extends Cubit<HoldSetState> {
  var userRepository = UserRepository();
  HoldSetCubit() : super(const HoldSetState()) {
    getHoldSet();
  }

  void getHoldSet() async {
    var response = await userRepository.getAllHoldSet();
    var lCache = await StorageUtils.getHoldSet();
    if (lCache.isNotEmpty) {
      emit(state.copyOf(
          lHoldSet: lCache, isLoading: false, status: HoldSetStatus.SUCCESS));
    }
    try {
      if (response.data != null && response.error == null) {
        var lResponse = holdSetModelFromJson(response.data);
        emit(state.copyOf(
            lHoldSet: lResponse,
            isLoading: false,
            status: HoldSetStatus.SUCCESS));
        StorageUtils.saveHoldSet(lResponse);
      } else {
        toast(response.error.toString());
        emit(state.copyOf(isLoading: false, status: HoldSetStatus.ERROR));
      }
    } catch (ex) {
      toast(ex.toString());
      emit(state.copyOf(isLoading: false, status: HoldSetStatus.ERROR));
    }
  }

  void selectOnClick(String icon, BuildContext context) =>
      RouterUtils.pop(context, result: icon, isHideBottomBar: true);

  void setIndex(int index) => emit(state.copyOf(currentIndex: index));

  void setFilter(SelectType type) => emit(state.copyOf(
      currentIndex: 0,
      type: type,
      lHoldSet: type == SelectType.ALL ? [] : []));

  void detailOnclick(context) =>
      RouterUtils.openNewPage(const HoldSetDetailPage(), context);
/*final List<HoldModel> fakePickAll = [
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
*/
}
