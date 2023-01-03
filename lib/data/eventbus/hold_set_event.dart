import 'package:base_bloc/data/model/hold_set_model.dart';

class HoldSetEvent {
  final HoldSetModel holdSet;
  final int holdSetIndex;

  const HoldSetEvent(this.holdSet, this.holdSetIndex);
}
