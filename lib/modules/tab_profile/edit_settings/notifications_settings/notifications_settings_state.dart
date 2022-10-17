import 'package:equatable/equatable.dart';

import '../../../../data/model/notifications_settings_model.dart';

enum NotificationsSettingsStatus { initial, success, failure, refresh }

class NotificationsSettingsState extends Equatable {
  final NotificationsSettingsStatus status;
  final int? timeStamp;
  List<NotificationsSettingsModel> notificationsSettingsList = [];

  NotificationsSettingsState(
      {this.timeStamp,
      this.status = NotificationsSettingsStatus.initial,
      this.notificationsSettingsList = const <NotificationsSettingsModel>[]});

  @override
  List<Object?> get props => [notificationsSettingsList, timeStamp, status];

  NotificationsSettingsState newState() =>
      NotificationsSettingsState(
          timeStamp: DateTime.now().millisecondsSinceEpoch,
          notificationsSettingsList: this.notificationsSettingsList,
          status: this.status);

}
