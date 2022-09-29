import 'package:base_bloc/modules/create_reservation/create_reservation_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/app_utils.dart';

class CreateReservationCubit extends Cubit<CreateReservationState> {
  CreateReservationCubit() : super(const CreateReservationState());

  void setTime(double startTime, double endTime) =>
      emit(state.copyOf(startTime: startTime, endTime: endTime));

  void addressOnclick(BuildContext context) async {
    Utils.hideKeyboard(context);
    var model = await RouterUtils.pushReservations(
        context: context, route: ReservationRouters.routesFilterAddress);
    emit(state.copyOf(addressModel: model));
  }
}
