import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_account/edit_account_page.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/privacy_settings/privacy_settings_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/log_utils.dart';
import '../../../utils/storage_utils.dart';
import 'edit_settings_state.dart';
import 'general_settings/general_settings_page.dart';
import 'notifications_settings/notifications_settings_page.dart';

enum SettingsItemType {
  ACCOUNT,
  NOTIFICATIONS,
  PRIVACY,
  GENERAL,
  LOGOUT
}

extension SettingsItemTypeExtension on SettingsItemType {
  String get icon {
    switch (this) {
      case SettingsItemType.ACCOUNT:
        return Assets.svg.icAccount;
      case SettingsItemType.NOTIFICATIONS:
        return Assets.svg.icNotification;
      case SettingsItemType.PRIVACY:
        return Assets.svg.icPrivacy;
      case SettingsItemType.GENERAL:
        return Assets.svg.icSetting;
      case SettingsItemType.LOGOUT:
        return Assets.svg.logout;

    }
  }

  String get title {
    switch (this) {
      case SettingsItemType.ACCOUNT:
        return LocaleKeys.settingsAccount;
      case SettingsItemType.NOTIFICATIONS:
        return LocaleKeys.settingsNotifications;
      case SettingsItemType.PRIVACY:
        return LocaleKeys.settingsPrivacy;
      case SettingsItemType.GENERAL:
        return LocaleKeys.settingsGeneral;
      case SettingsItemType.LOGOUT:
        return LocaleKeys.logOut;
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
    SettingsModel(SettingsItemType.GENERAL),
    SettingsModel(SettingsItemType.LOGOUT)
  ];

  void openAccountPage(BuildContext context) {
    RouterUtils.openNewPage(EditAccountPage(), context);
  }

  void openNotificationsSettingsPage(BuildContext context) {
    RouterUtils.openNewPage(NotificationsSettingsPage(), context);
  }

  void openPrivacySettingsPage(BuildContext context) {
    RouterUtils.openNewPage(PrivacySettingsPage(), context);
  }

  void openGeneralSettingsPage(BuildContext context) {
    RouterUtils.openNewPage(GeneralSettingsPage(), context);
  }

  void logOut(BuildContext context){
    StorageUtils.setLogin(false);
     emit(EditSettingsState(timeStamp: DateTime.now().microsecondsSinceEpoch));
    toast('LogOut success');
    RouterUtils.openNewPage(const HomePage(), context);
  }
}