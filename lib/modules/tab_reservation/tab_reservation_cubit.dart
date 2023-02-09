import 'dart:async';
import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
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
  void onClickNotification(BuildContext context) => /*toast(LocaleKeys.thisFeatureIsUnder);*/
      RouterUtils.pushReservations(
      context: context,
      route: ReservationRouters.notifications,
      argument: BottomNavigationConstant.TAB_RESERVATIONS);

  void onClickSearch(BuildContext context) => RouterUtils.pushReservations(
      context: context,
      route: ReservationRouters.search,
      argument: BottomNavigationConstant.TAB_RESERVATIONS);

  void itemOnclick(BuildContext context, ReservationModel model) =>
      RouterUtils.pushReservations(
          context: context,
          route: ReservationRouters.routesReservationDetail,
          argument: [BottomNavigationConstant.TAB_RESERVATIONS,model]);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushReservations(
        context: context,
        route: ReservationRouters.login,
        argument: BottomNavigationConstant.TAB_RESERVATIONS);
    emit(state.copyOf(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void addOnclick(BuildContext context) =>
      RouterUtils.pushReservations(route: ReservationRouters.routesCreateReservationPage, context: context,argument: BottomNavigationConstant.TAB_RESERVATIONS);
  List<ReservationModel> fakeData() => [
        ReservationModel(
            calendar: DateTime.now(),
            startTime: '9:30',
            endTime: '10:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Murall',
            isCheck: false, city: 'Warsaw'),
/*        ReservationModel(
            calendar: DateTime.now(),
            startTime: '10:30',
            endTime: '11:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Kawasai',
            isCheck: false, city: 'Warsaw'),
        ReservationModel(
            calendar: DateTime.now(),
            startTime: '11:30',
            endTime: '12:30',
            address:
                'Wall no. 3 - Next to window Centurn Murall al.Kwasaaki 61 02-183 warsawa',
            status: 'Kawasai',
            isCheck: true, city: 'Warsaw'),*/
      ];
}
