import 'package:base_bloc/data/model/hold_set_model.dart';

class ListHoldSetEvent {
  final List<HoldSetModel> holdSet;
  final int holdSetIndex;

  const ListHoldSetEvent(this.holdSet, this.holdSetIndex);
}
