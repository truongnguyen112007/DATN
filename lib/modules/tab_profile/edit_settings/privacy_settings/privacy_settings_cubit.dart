import 'package:base_bloc/modules/tab_profile/edit_settings/privacy_settings/privacy_setting_state.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/model/general_action_sheet_model.dart';
import '../../../../data/model/privacy_settings_model.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../localization/locale_keys.dart';

enum PrivacySettingsItemValue {
  PUBLIC,
  FRIENDS,
  PRIVATE
}

extension PrivacySettingsItemValueExtension on PrivacySettingsItemValue {
  String get title {
    switch (this) {
      case PrivacySettingsItemValue.PUBLIC:
        return LocaleKeys.privacy_public.tr();
      case PrivacySettingsItemValue.FRIENDS:
        return LocaleKeys.privacy_friends.tr();
      case PrivacySettingsItemValue.PRIVATE:
        return LocaleKeys.privacy_private.tr();
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
  String get title {
    switch (this) {
      case PrivacySettingsItemType.POST:
        return LocaleKeys.privacy_post;
      case PrivacySettingsItemType.ROUTES:
        return LocaleKeys.privacy_routes;
      case PrivacySettingsItemType.VIDEO:
        return LocaleKeys.privacy_video;
      case PrivacySettingsItemType.MY_FRIENDS_LIST:
        return LocaleKeys.privacy_friends_list;
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

  void showPrivacyOption(BuildContext context, PrivacySettingsModel item) {
    List<GeneralActionSheetModel> privacyActionSheetModels = PrivacySettingsItemValue.values.map((e) => GeneralActionSheetModel(e.title, icon: e.icon.image(height: 24.h, width: 24.w, color: Colors.white70))).toList();
    UtilsExtension.showGeneralOptionActionDialog(context, privacyActionSheetModels, (p0) {
      PrivacySettingsItemValue? selectedValue = PrivacySettingsItemValue.values.firstWhere((element) => element.title == p0.value);
      PrivacySettingsModel newItem = PrivacySettingsModel(item.type, selectedValue);
      state.privacySettingsList[state.privacySettingsList.indexWhere((element) => element.type == item.type)] = newItem;
      updatePrivacySettingsState();
    });
  }

}