import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/notifications_settings_model.dart';
import 'notifications_settings_state.dart';

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

class NotificationsSettingsCubit extends Cubit<NotificationsSettingsState> {
  NotificationsSettingsCubit() : super(NotificationsSettingsState(status: NotificationsSettingsStatus.initial)) {
    if (state.status == NotificationsSettingsStatus.initial) {
      initNotificationsSettingsList();
    }
  }

  void updateNotificationsSettingsState() {
    emit(state.newState());
  }

  void initNotificationsSettingsList() {
    state.notificationsSettingsList = [
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