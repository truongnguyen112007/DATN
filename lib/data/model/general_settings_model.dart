
import 'package:base_bloc/modules/tab_profile/edit_settings/general_settings/general_settings_cubit.dart';

class GeneralSettingsModel {
  final GeneralSettingsItemType type;
  final String value;
  final GeneralSettingsLanguageValue? languageValue;

  GeneralSettingsModel(this.type, this.value,{this.languageValue});
}

