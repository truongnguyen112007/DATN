import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/notification_model.dart';
import '../../utils/log_utils.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState(status: NotificationsStatus.initial)) {
    if (state.status == NotificationsStatus.initial) {
      getNotifications();
    }
  }

  void getNotifications({bool isPaging = false}) {
    if (state.readEnd) return;
    if (isPaging) {
      Timer(const Duration(seconds: 1), () {
        emit(state.copyOf(lActivities: List.of(state.lActivities)..addAll(fakeActivities()), readEnd: true));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        emit(NotificationsState(
            readEnd: false,
            lInvitations: fakeInvitations(),
            lActivities: fakeActivities(),
            status: NotificationsStatus.success,
            currentPage: 1));
      });
    }
  }

  void refresh() {
    emit(NotificationsState(status: NotificationsStatus.refresh));
    getNotifications();
  }

  void itemOnclick(BuildContext context, NotificationModel model) => print("TRUNGHD");

  List<NotificationModel> fakeInvitations() => [
    NotificationModel(title: 'Michael Bavaria',
      content: '2 mutual connections',
      date: '',
      image: 'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129',
    ),
    NotificationModel(title: 'John Estanie',
      content: '0 mutual connections',
      date: '',
      image: 'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129',
    )
  ];

  List<NotificationModel> fakeActivities() => [
    NotificationModel(title: 'Zoe Smith',
    content: 'commented your post',
    date: '1 day',
    image: 'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129',
    ),
    NotificationModel(title: 'Zoe Smith',
      content: 'liked your post',
      date: '1 day',
      image: 'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129',
    ),
    NotificationModel(title: 'Paul',
      content: 'liked your post',
      date: '1 day',
      image: 'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129',
    ),
    NotificationModel(title: 'Paul',
      content: 'commented your post',
      date: '1 day',
      image: 'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129',
    )
  ];

}