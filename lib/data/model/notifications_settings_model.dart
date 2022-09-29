
import '../../modules/tab_profile/edit_settings/notifications_settings/notifications_settings_state.dart';

class NotificationsSettingsModel {
  final NotificationSettingItemType type;
  bool isEnable;

  NotificationsSettingsModel(this.type, this.isEnable);
}
