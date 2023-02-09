import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/modules/hold_set/hold_set_state.dart';
import 'package:base_bloc/modules/hold_set_detail/hold_set_detail_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/hold_set_model.dart';


class HoldSetCubit extends Cubit<HoldSetState> {
  var userRepository = UserRepository();

  HoldSetCubit(int holdSetIndex) : super(HoldSetState()) {
    state.currentIndex = holdSetIndex;
    getHoldSet();
  }

  void getHoldSet() async {
    var lCache = await StorageUtils.getHoldSet();
    if (lCache.isNotEmpty) {
      emit(state.copyOf(
          lHoldSet: lCache, isLoading: false, status: HoldSetStatus.SUCCESS));
    }
    var response = await userRepository.getAllHoldSet();
    try {
      if (response.data != null && response.error == null) {
        var lResponse = holdSetModelFromJson(response.data);
        emit(state.copyOf(
            lHoldSet: lResponse,
            isLoading: false,
            status: HoldSetStatus.SUCCESS));
        StorageUtils.saveHoldSets(lResponse);
      } else {
        toast(response.error.toString());
        emit(state.copyOf(isLoading: false, status: HoldSetStatus.ERROR));
      }
    } catch (ex) {
      toast(ex.toString());
      emit(state.copyOf(isLoading: false, status: HoldSetStatus.ERROR));
    }
  }

  void selectOnClick(HoldSetModel icon, BuildContext context) =>
      RouterUtils.pop(context,
          result: [icon, state.currentIndex], isHideBottomBar: true);

  void setIndex(int index) => emit(state.copyOf(currentIndex: index));

  void setFilter(SelectType type) => emit(state.copyOf(
      currentIndex: 0,
      type: type));

  void detailOnclick(context) =>
      RouterUtils.openNewPage(const HoldSetDetailPage(), context);
}
