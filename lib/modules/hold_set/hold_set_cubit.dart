import 'package:base_bloc/modules/hold_set/hold_set_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gen/assets.gen.dart';

class HoldSetCubit extends Cubit<HoldSetState> {
  HoldSetCubit() : super(const HoldSetState()) {
    emit(state.copyOf(lHoldSet: fakePickAll));
  }

  void setIndex(int index) => emit(state.copyOf(currentIndex: index));

  void setFilter(SelectType type) => emit(state.copyOf(
      type: type,
      lHoldSet: type == SelectType.ALL ? fakePickAll : fakePickFavourite));

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
