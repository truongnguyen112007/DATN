import 'package:equatable/equatable.dart';
import '../../../../data/model/privacy_settings_model.dart';

enum PrivacySettingsStatus { initial, success, failure, refresh }

class PrivacySettingsState extends Equatable {
  final PrivacySettingsStatus status;
  final int? timeStamp;
  List<PrivacySettingsModel> privacySettingsList = [];

  PrivacySettingsState(
      {this.timeStamp,
        this.status = PrivacySettingsStatus.initial,
        this.privacySettingsList = const <PrivacySettingsModel>[]});

  @override
  List<Object?> get props => [privacySettingsList, timeStamp, status];

  PrivacySettingsState newState() =>
      PrivacySettingsState(
          timeStamp: DateTime.now().millisecondsSinceEpoch,
          privacySettingsList: this.privacySettingsList,
          status: this.status);

}
