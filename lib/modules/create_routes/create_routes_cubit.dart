import 'dart:async';
import 'dart:math';

import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';
import '../../router/router_utils.dart';
import '../hold_set/hold_set_page.dart';

class CreateRoutesCubit extends Cubit<CreateRoutesState> {
  CreateRoutesCubit() : super(const CreateRoutesState());

  void itemOnLongPress(int index, BuildContext context) async {
    emit(state.copyOf(selectIndex: index));
    var result = await RouterUtils.openNewPage(HoldSetPage(), context);
    if (result != null) {
      state.lBox[index] = result;
      emit(state.copyOf(
          lBox: state.lBox, timeStamp: DateTime.now().microsecondsSinceEpoch));
    }
  }

  void itemOnClick(int index){
    state.lBox[index] = lHoldSet[Random().nextInt(5)];
    emit(state.copyOf(
        lBox: state.lBox, timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void setData({required int width, required int height, required int size}) {
    var row = width ~/ size;
    var column = height ~/ size;
    var lBox = <String>[];
    for (int i = 0; i < row * column; i++) {
      lBox.add('');
    }
    Timer(
        const Duration(seconds: 1),
        () => emit(state.copyOf(
            status: StatusType.success,
            column: column,
            row: row,
            sizeBox: size,
            lBox: lBox)));
  }

  void holdSetOnClick(BuildContext context) =>
      RouterUtils.openNewPage(const HoldSetPage(), context);

  final List<String> lHoldSet = [
    Assets.png.climbing1.path,
    Assets.png.climbing2.path,
    Assets.png.climbing3.path,
    Assets.png.climbing4.path,
    Assets.png.climbing5.path
  ];
}
