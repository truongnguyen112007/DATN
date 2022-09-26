import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_settings_state.dart';

enum SettingsItemType {
  ACCOUNT,
  NOTIFICATIONS,
  PRIVACY,
  GENERAL,
}

extension SettingsItemActionExtension on SettingsItemType {
  AssetGenImage get icon {
    switch (this) {
      case SettingsItemType.ACCOUNT:
        return Assets.png.climbing5;
      case SettingsItemType.NOTIFICATIONS:
        return Assets.png.climbing2;
      case SettingsItemType.PRIVACY:
        return Assets.png.climbing3;
      case SettingsItemType.GENERAL:
        return Assets.png.climbing4;
    }
  }
}

class EditSettingsCubit extends Cubit<EditSettingsState> {
  EditSettingsCubit() : super(const EditSettingsState(status: EditSettingsStatus.initial)) {
    if (state.status == EditSettingsStatus.initial) {
    }
  }

  List<SettingsModel> settingsList(BuildContext context) => [
    SettingsModel(SettingsItemType.ACCOUNT, AppLocalizations.of(context)!.settingsAccount),
    SettingsModel(SettingsItemType.NOTIFICATIONS, AppLocalizations.of(context)!.settingsNotifications),
    SettingsModel(SettingsItemType.PRIVACY, AppLocalizations.of(context)!.settingsPrivacy),
    SettingsModel(SettingsItemType.GENERAL, AppLocalizations.of(context)!.settingsGeneral),
  ];

  void openAccountPage() {
    print('ACCOUNT');
  }

}