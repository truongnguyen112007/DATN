import 'package:base_bloc/modules/zoom_routes/zoom_routes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/hold_set_model.dart';

class ZoomRoutesCubit extends Cubit<ZoomRoutesState> {
  ZoomRoutesCubit() : super(ZoomRoutesState());

  void setInfo(int row, int column, double sizeHoldSet,
          List<HoldSetModel> lRoutes) =>
      emit(state.copyOf(
          row: row,
          column: column,
          sizeHoldSet: sizeHoldSet,
          lRoutes: lRoutes));
}
