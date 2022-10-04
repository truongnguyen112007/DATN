import 'package:base_bloc/data/model/address_model.dart';
import 'package:base_bloc/data/model/list_places_model.dart';
import 'package:base_bloc/modules/confirm_create_reservation/confirm_create_reservation_state.dart';
import 'package:base_bloc/modules/create_reservation/create_reservation_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../router/router.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';
import '../find_place/find_place_page.dart';

class ConfirmCreateReservationCubit
    extends Cubit<ConfirmCreateReservationState> {
  ConfirmCreateReservationCubit()
      : super(const ConfirmCreateReservationState());

  void placeOnclick(BuildContext context) async {
    Utils.hideKeyboard(context);
    var model = await RouterUtils.openNewPage(const FindPlacePage(), context);
    emit(state.copyOf(placesModel: model));
  }

  void addressOnclick(BuildContext context) async {
    Utils.hideKeyboard(context);
    var model = await RouterUtils.pushReservations(
        context: context, route: ReservationRouters.routesFilterAddress);
    emit(state.copyOf(addressModel: model));
  }

  void setData(
          AddressModel addressModel, PlacesModel placesModel, DateTime time) =>
      emit(state.copyOf(
          addressModel: addressModel,
          placesModel: placesModel,
          dateTime: time));
}
