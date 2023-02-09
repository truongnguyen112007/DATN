import 'package:equatable/equatable.dart';
import '../../../../data/model/general_settings_model.dart';

enum GeneralSettingsStatus { initial, success, failure, refresh }

class GeneralSettingsState extends Equatable {
  final GeneralSettingsStatus status;
  final int? timeStamp;
  List<GeneralSettingsModel> generalSettingsList = [];

  GeneralSettingsState(
      {this.timeStamp,
        this.status = GeneralSettingsStatus.initial,
        this.generalSettingsList = const <GeneralSettingsModel>[]});

  @override
  List<Object?> get props => [generalSettingsList, timeStamp, status];

  GeneralSettingsState newState() =>
      GeneralSettingsState(
          timeStamp: DateTime.now().millisecondsSinceEpoch,
          generalSettingsList: this.generalSettingsList,
          status: this.status);

}
