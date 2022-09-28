import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_account/edit_account_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_settings_state.dart';
import 'notifications_settings/notifications_settings_page.dart';

enum SettingsItemType {
  ACCOUNT,
  NOTIFICATIONS,
  PRIVACY,
  GENERAL,
}

extension SettingsItemTypeExtension on SettingsItemType {
  AssetGenImage get icon {
    switch (this) {
      case SettingsItemType.ACCOUNT:
        return Assets.png.icAccount;
      case SettingsItemType.NOTIFICATIONS:
        return Assets.png.icNotification;
      case SettingsItemType.PRIVACY:
        return Assets.png.icPrivacy;
      case SettingsItemType.GENERAL:
        return Assets.png.icSetting;
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case SettingsItemType.ACCOUNT:
        return AppLocalizations.of(context)!.settingsAccount;
      case SettingsItemType.NOTIFICATIONS:
        return AppLocalizations.of(context)!.settingsNotifications;
      case SettingsItemType.PRIVACY:
        return AppLocalizations.of(context)!.settingsPrivacy;
      case SettingsItemType.GENERAL:
        return AppLocalizations.of(context)!.settingsGeneral;
    }
  }
}

class EditSettingsCubit extends Cubit<EditSettingsState> {
  EditSettingsCubit() : super(const EditSettingsState(status: EditSettingsStatus.initial)) {
    if (state.status == EditSettingsStatus.initial) {
    }
  }

  List<SettingsModel> settingsList(BuildContext context) => [
    SettingsModel(SettingsItemType.ACCOUNT),
    SettingsModel(SettingsItemType.NOTIFICATIONS),
    SettingsModel(SettingsItemType.PRIVACY),
    SettingsModel(SettingsItemType.GENERAL)
  ];

  void openAccountPage(BuildContext context) {
    RouterUtils.openNewPage(EditAccountPage(), context);
  }

  void openNotificationsSettingsPage(BuildContext context) {
    RouterUtils.openNewPage(NotificationsSettingsPage(), context);
  }

}