import 'dart:ui';
import '../../modules/tab_profile/edit_settings/edit_settings_cubit.dart';

class SettingsModel {
  final SettingsItemType type;
  final Color? color;

  SettingsModel({required this.type, this.color});
}
