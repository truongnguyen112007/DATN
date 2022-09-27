import 'dart:async';
import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../router/router.dart';

class TabReservationCubit extends Cubit<TabReservationState> {
  TabReservationCubit()
      : super(const TabReservationState(status: StatusType.initial)) {
    if (state.status == StatusType.initial) {
      getFeed();
    }
  }

  void getFeed({bool isPaging = false}) {
    if (state.readEnd) return;
    if (isPaging) {
      Timer(const Duration(seconds: 1), () {
        emit(state.copyOf(
            lToday: List.of(state.lToday)..addAll(fakeData()), readEnd: true));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        emit(TabReservationState(
            readEnd: false,
            lToday: fakeData(),
            lNextWeek: fakeData(),
            lTomorrow: fakeData(),
            status: StatusType.success,
            currentPage: 1));
      });
    }
  }

  void refresh() {
    emit(const TabReservationState(status: StatusType.refresh));
    getFeed();
  }
  void itemOnclick(BuildContext context, ReservationModel model) =>
      RouterUtils.pushReservations(
          context: context,
          route: ReservationRouters.routesReservationDetail,
          argument: model);

  List<ReservationModel> fakeData() => [
        ReservationModel(
            calendar: DateTime.now(),
            startTime: '9:30',
            endTime: '10:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Murall Warsaw',
            isCheck: false),
        ReservationModel(
            calendar: DateTime.now(),
            startTime: '10:30',
            endTime: '11:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Kawasai Warsaw',
            isCheck: false),
        ReservationModel(
            calendar: DateTime.now(),
            startTime: '11:30',
            endTime: '12:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Kawasai Warsaw',
            isCheck: true),
      ];
}
