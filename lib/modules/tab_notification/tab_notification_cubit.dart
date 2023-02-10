import 'dart:async';
import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:base_bloc/modules/tab_notification/tab_notification_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../data/model/notification_model.dart';
import '../../router/router.dart';

class TabNotificationCubit extends Cubit<TabNotificationState> {
  TabNotificationCubit()
      : super(const TabNotificationState(status: StatusType.initial)) {
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
        emit(TabNotificationState(
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
    emit(const TabNotificationState(status: StatusType.refresh));
    getFeed();
  }
  void onClickNotification(BuildContext context) => /*toast(LocaleKeys.thisFeatureIsUnder);*/
      RouterUtils.pushNotification(
      context: context,
      route: NotificationRouters.notifications,
      argument: BottomNavigationConstant.TAB_RESERVATIONS);

  void onClickSearch(BuildContext context) => RouterUtils.pushNotification(
      context: context,
      route: NotificationRouters.search,
      argument: BottomNavigationConstant.TAB_RESERVATIONS);

  void itemOnclick(BuildContext context, ReservationModel model) =>
      RouterUtils.pushNotification(
          context: context,
          route: NotificationRouters.routesReservationDetail,
          argument: [BottomNavigationConstant.TAB_RESERVATIONS,model]);

  void onClickLogin(BuildContext context) async {
    await RouterUtils.pushNotification(
        context: context,
        route: NotificationRouters.login,
        argument: BottomNavigationConstant.TAB_RESERVATIONS);
    emit(state.copyOf(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void addOnclick(BuildContext context) =>
      RouterUtils.pushNotification(route: NotificationRouters.routesCreateReservationPage, context: context,argument: BottomNavigationConstant.TAB_RESERVATIONS);
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

List<NotificationModel> fakeDataNotification() => [
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "12/1/2023"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "20/12/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "9/12/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "1/12/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "20/11/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "14/11/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "12/10/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "10/10/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "8/9/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "2/9/2022"),
  NotificationModel("Đang có hàng hóa", "vượt định mức tồn tại", "20/7/2022"),
];
