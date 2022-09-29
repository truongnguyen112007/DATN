import 'package:base_bloc/modules/tab_profile/edit_settings/privacy_settings/privacy_setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/privacy_settings_model.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../localizations/app_localazations.dart';

enum PrivacySettingsItemValue {
  PUBLIC,
  FRIENDS,
  PRIVATE
}

extension PrivacySettingsItemValueExtension on PrivacySettingsItemValue {
  String title(BuildContext context) {
    switch (this) {
      case PrivacySettingsItemValue.PUBLIC:
        return AppLocalizations.of(context)!.privacy_public;
      case PrivacySettingsItemValue.FRIENDS:
        return AppLocalizations.of(context)!.privacy_friends;
      case PrivacySettingsItemValue.PRIVATE:
        return AppLocalizations.of(context)!.privacy_private;
    }
  }

  AssetGenImage get icon {
    switch (this) {
      case PrivacySettingsItemValue.PUBLIC:
        return Assets.png.icPublic;
      case PrivacySettingsItemValue.FRIENDS:
        return Assets.png.icFriends;
      case PrivacySettingsItemValue.PRIVATE:
        return Assets.png.icPrivate;
    }
  }
}

enum PrivacySettingsItemType {
  POST,
  ROUTES,
  VIDEO,
  MY_FRIENDS_LIST
}

extension PrivacySettingsItemTypeExtension on PrivacySettingsItemType {
  String title(BuildContext context) {
    switch (this) {
      case PrivacySettingsItemType.POST:
        return AppLocalizations.of(context)!.privacy_post;
      case PrivacySettingsItemType.ROUTES:
        return AppLocalizations.of(context)!.privacy_routes;
      case PrivacySettingsItemType.VIDEO:
        return AppLocalizations.of(context)!.privacy_video;
      case PrivacySettingsItemType.MY_FRIENDS_LIST:
        return AppLocalizations.of(context)!.privacy_friends_list;
    }
  }
}

class PrivacySettingsCubit extends Cubit<PrivacySettingsState> {
  PrivacySettingsCubit() : super(PrivacySettingsState(status: PrivacySettingsStatus.initial)) {
    if (state.status == PrivacySettingsStatus.initial) {
      initPrivacySettingsList();
    }
  }

  void updatePrivacySettingsState() {
    emit(state.newState());
  }

  void initPrivacySettingsList() {
    state.privacySettingsList = [
      PrivacySettingsModel(
          PrivacySettingsItemType.POST, PrivacySettingsItemValue.PUBLIC),
      PrivacySettingsModel(
          PrivacySettingsItemType.ROUTES, PrivacySettingsItemValue.PUBLIC),
      PrivacySettingsModel(PrivacySettingsItemType.VIDEO, PrivacySettingsItemValue.FRIENDS),
      PrivacySettingsModel(PrivacySettingsItemType.MY_FRIENDS_LIST, PrivacySettingsItemValue.PRIVATE)
    ];
  }

}