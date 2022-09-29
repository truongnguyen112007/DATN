import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/model/notifications_settings_model.dart';
import '../../../../localizations/app_localazations.dart';
import 'notifications_settings_cubit.dart';

enum NotificationSettingItemType {
  RESERVATIONS,
  INVITATION_TO_FRIENDS,
  COMMENTS,
  LIKES,
  SHARING
}

extension NotificationSettingItemTypeExtension on NotificationSettingItemType {
  String title(BuildContext context) {
    switch (this) {
      case NotificationSettingItemType.RESERVATIONS:
        return AppLocalizations.of(context)!.notif_reservations;
      case NotificationSettingItemType.INVITATION_TO_FRIENDS:
        return AppLocalizations.of(context)!.notif_invitation_to_friends;
      case NotificationSettingItemType.COMMENTS:
        return AppLocalizations.of(context)!.notif_comments;
      case NotificationSettingItemType.LIKES:
        return AppLocalizations.of(context)!.notif_likes;
      case NotificationSettingItemType.SHARING:
        return AppLocalizations.of(context)!.notif_sharing;
    }
  }
}

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

  void initNotificationsSettingsList() {
    notificationsSettingsList = [
      NotificationsSettingsModel(
          NotificationSettingItemType.RESERVATIONS, true),
      NotificationsSettingsModel(
          NotificationSettingItemType.INVITATION_TO_FRIENDS, false),
      NotificationsSettingsModel(NotificationSettingItemType.COMMENTS, false),
      NotificationsSettingsModel(NotificationSettingItemType.LIKES, true),
      NotificationsSettingsModel(NotificationSettingItemType.SHARING, true)
    ];
  }
}
