import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/general_action_sheet_model.dart';
import '../../../../data/model/general_settings_model.dart';
import '../../../../data/model/privacy_settings_model.dart';
import '../../../../localizations/app_localazations.dart';
import '../../../../utils/app_utils.dart';
import '../privacy_settings/privacy_settings_cubit.dart';
import 'general_settings_state.dart';

enum GeneralSettingsItemType {
  LANGUAGE,
  SYSTEM_OF_MEASUREMENT,
  GRADE_SCALE,
}

extension GeneralSettingsItemTypeExtension on GeneralSettingsItemType {
  String get title {
    switch (this) {
      case GeneralSettingsItemType.LANGUAGE:
        return LocaleKeys.general_settings_language;
      case GeneralSettingsItemType.SYSTEM_OF_MEASUREMENT:
        return LocaleKeys.general_settings_system_measurement;
      case GeneralSettingsItemType.GRADE_SCALE:
        return LocaleKeys.general_settings_grade_scale;
    }
  }
}

enum GeneralSettingsLanguageValue { ENGLISH, POLAND }

extension GeneralSettingsLanguageValueExtension
    on GeneralSettingsLanguageValue {
  String get title {
    switch (this) {
      case GeneralSettingsLanguageValue.ENGLISH:
        return LocaleKeys.general_settings_language_english;
      case GeneralSettingsLanguageValue.POLAND:
        return LocaleKeys.general_settings_language_poland;
    }
  }
}

enum GeneralSettingsSystemMeasurementValue {
  METRIC,
  IMPERIAL_UNITS,
}

extension GeneralSettingsSystemMeasurementValueExtension
    on GeneralSettingsSystemMeasurementValue {
  String get title {
    switch (this) {
      case GeneralSettingsSystemMeasurementValue.METRIC:
        return LocaleKeys.general_settings_system_measurement_meters;
      case GeneralSettingsSystemMeasurementValue.IMPERIAL_UNITS:
        return LocaleKeys.general_settings_system_measurement_imperial_units;
    }
  }
}

enum GeneralSettingsGradeScaleValue { FRENCH, NORDIC, USA, BRITISH }

extension GeneralSettingsGradeScaleValueExtension
    on GeneralSettingsGradeScaleValue {
  String get title {
    switch (this) {
      case GeneralSettingsGradeScaleValue.FRENCH:
        return LocaleKeys.general_settings_grade_scale_french;
      case GeneralSettingsGradeScaleValue.NORDIC:
        return LocaleKeys.general_settings_grade_scale_nordic;
      case GeneralSettingsGradeScaleValue.USA:
        return LocaleKeys.general_settings_grade_scale_usa;
      case GeneralSettingsGradeScaleValue.BRITISH:
        return LocaleKeys.general_settings_grade_scale_british;
    }
  }
}

class GeneralSettingsCubit extends Cubit<GeneralSettingsState> {
  GeneralSettingsCubit()
      : super(GeneralSettingsState(status: GeneralSettingsStatus.initial)) {
    if (state.status == GeneralSettingsStatus.initial) {
      initGeneralSettingsList();
    }
  }

  void updateGeneralSettingsState() {
    emit(state.newState());
  }

  void initGeneralSettingsList() {
    state.generalSettingsList = [
      GeneralSettingsModel(GeneralSettingsItemType.LANGUAGE,
          GeneralSettingsLanguageValue.ENGLISH.title),
      GeneralSettingsModel(GeneralSettingsItemType.SYSTEM_OF_MEASUREMENT,
          GeneralSettingsSystemMeasurementValue.METRIC.title),
      GeneralSettingsModel(GeneralSettingsItemType.GRADE_SCALE,
          GeneralSettingsGradeScaleValue.FRENCH.title),
    ];
  }

  void showGeneralSettingsOption(
      BuildContext context, GeneralSettingsModel item) {
    List<GeneralActionSheetModel> languagesActionSheetModels = [];

    switch (item.type) {
      case GeneralSettingsItemType.LANGUAGE:
        languagesActionSheetModels = GeneralSettingsLanguageValue.values
            .map((e) => GeneralActionSheetModel(e.title))
            .toList();
        break;
      case GeneralSettingsItemType.SYSTEM_OF_MEASUREMENT:
        languagesActionSheetModels = GeneralSettingsSystemMeasurementValue.values
            .map((e) => GeneralActionSheetModel(e.title))
            .toList();
        break;
      case GeneralSettingsItemType.GRADE_SCALE:
        languagesActionSheetModels = GeneralSettingsGradeScaleValue.values
            .map((e) => GeneralActionSheetModel(e.title))
            .toList();
        break;
    }

    UtilsExtension.showGeneralOptionActionDialog(
        context, languagesActionSheetModels, (p0) {
      GeneralSettingsModel newItem = GeneralSettingsModel(item.type, p0.value);
      state.generalSettingsList[state.generalSettingsList
          .indexWhere((element) => element.type == item.type)] = newItem;
      updateGeneralSettingsState();
    });
  }
}
