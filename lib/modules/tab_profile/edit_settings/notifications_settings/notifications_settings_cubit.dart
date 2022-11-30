import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/notifications_settings_model.dart';
import '../../../../localization/locale_keys.dart';
import 'notifications_settings_state.dart';

enum NotificationSettingItemType {
  RESERVATIONS,
  INVITATION_TO_FRIENDS,
  COMMENTS,
  LIKES,
  SHARING
}

extension NotificationSettingItemTypeExtension on NotificationSettingItemType {
  String get title {
    switch (this) {
      case NotificationSettingItemType.RESERVATIONS:
        return LocaleKeys.notif_reservations.tr();
      case NotificationSettingItemType.INVITATION_TO_FRIENDS:
        return LocaleKeys.notif_invitation_to_friends.tr();
      case NotificationSettingItemType.COMMENTS:
        return LocaleKeys.notif_comments.tr();
      case NotificationSettingItemType.LIKES:
        return LocaleKeys.notif_likes.tr();
      case NotificationSettingItemType.SHARING:
        return LocaleKeys.notif_sharing.tr();
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