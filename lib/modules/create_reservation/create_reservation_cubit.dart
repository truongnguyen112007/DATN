import 'package:base_bloc/data/eventbus/new_page_event.dart';
import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/modules/create_reservation/create_reservation_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../localization/locale_keys.dart';
import '../../utils/app_utils.dart';

class CreateReservationCubit extends Cubit<CreateReservationState> {
  CreateReservationCubit() : super(const CreateReservationState());

  void setTime(double startTime, double endTime) =>
      emit(state.copyOf(startTime: startTime, endTime: endTime));

  void placeOnclick(BuildContext context) async {
    Utils.hideKeyboard(context);
  }

  void setPlace(PlacesModel model) => emit(state.copyOf(placesModel: model));

  void addressOnclick(BuildContext context) async {
    Utils.hideKeyboard(context);
    var model = await RouterUtils.pushNotification(
        context: context, route: NotificationRouters.routesFilterAddress);
    emit(state.copyOf(addressModel: model));
  }

  void timeOnclick(BuildContext context,DateTime dateTime) {
    if (state.placesModel == null || state.addressModel == null) {
      toast(LocaleKeys.please_input_information.tr());
      return;
    }
    RouterUtils.pushNotification(
        context: context,
        route: NotificationRouters.routesConfirmCreateReservation,
        argument: [state.addressModel, state.placesModel, dateTime]);
  }
}
