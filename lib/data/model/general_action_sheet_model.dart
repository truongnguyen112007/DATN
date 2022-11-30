
import 'package:flutter/widgets.dart';

import '../../modules/tab_profile/edit_settings/general_settings/general_settings_cubit.dart';

class GeneralActionSheetModel {
  Image? icon;
  String value;
  GeneralSettingsLanguageValue? languageValue;
  GeneralActionSheetModel(this.value, {this.icon,this.languageValue});

}

