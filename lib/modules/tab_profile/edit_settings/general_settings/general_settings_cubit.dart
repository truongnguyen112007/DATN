import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/storage_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/general_action_sheet_model.dart';
import '../../../../data/model/general_settings_model.dart';
import '../../../../localization/codegen_loader.g.dart';
import '../../../../localization/locale_keys.dart';
import '../../../../utils/app_utils.dart';
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
        return LocaleKeys.general_settings_language.tr();
      case GeneralSettingsItemType.SYSTEM_OF_MEASUREMENT:
        return LocaleKeys.general_settings_system_measurement.tr();
      case GeneralSettingsItemType.GRADE_SCALE:
        return LocaleKeys.general_settings_grade_scale.tr();
    }
  }
}

enum GeneralSettingsLanguageValue { ENGLISH, POLAND }

extension GeneralSettingsLanguageValueExtension
    on GeneralSettingsLanguageValue {
  String get title {
    switch (this) {
      case GeneralSettingsLanguageValue.ENGLISH:
        return LocaleKeys.general_settings_language_english.tr();
      case GeneralSettingsLanguageValue.POLAND:
        return LocaleKeys.general_settings_language_poland.tr();
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
        return LocaleKeys.general_settings_system_measurement_meters.tr();
      case GeneralSettingsSystemMeasurementValue.IMPERIAL_UNITS:
        return LocaleKeys.general_settings_system_measurement_imperial_units.tr();
    }
  }
}

enum GeneralSettingsGradeScaleValue { FRENCH, NORDIC, USA, BRITISH }

extension GeneralSettingsGradeScaleValueExtension
    on GeneralSettingsGradeScaleValue {
  String get title {
    switch (this) {
      case GeneralSettingsGradeScaleValue.FRENCH:
        return LocaleKeys.general_settings_grade_scale_french.tr();
      case GeneralSettingsGradeScaleValue.NORDIC:
        return LocaleKeys.general_settings_grade_scale_nordic.tr();
      case GeneralSettingsGradeScaleValue.USA:
        return LocaleKeys.general_settings_grade_scale_usa.tr();
      case GeneralSettingsGradeScaleValue.BRITISH:
        return LocaleKeys.general_settings_grade_scale_british.tr();
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

  void initGeneralSettingsList() async{
    state.generalSettingsList = [
      GeneralSettingsModel(
          GeneralSettingsItemType.LANGUAGE,
          globals.languageCode == Applocalizations.enCode
              ? GeneralSettingsLanguageValue.ENGLISH.title
              : GeneralSettingsLanguageValue.POLAND.title),
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
            .map((e) => GeneralActionSheetModel(e.title, languageValue: e))
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
        context, languagesActionSheetModels, (p0) async {
      GeneralSettingsModel newItem = GeneralSettingsModel(item.type, p0.value);
      if (item.type == GeneralSettingsItemType.LANGUAGE) {
        if (p0.languageValue == GeneralSettingsLanguageValue.ENGLISH) {
          await context.setLocale(Applocalizations.localeEn);
          StorageUtils.saveLanguageCode(Applocalizations.enCode);
        } else {
          await context.setLocale(Applocalizations.localePl);
          StorageUtils.saveLanguageCode(Applocalizations.plCode);
        }
        RouterUtils.openNewPage(HomePage(), context, isReplace: true);
      }
      state.generalSettingsList[state.generalSettingsList
          .indexWhere((element) => element.type == item.type)] = newItem;
      updateGeneralSettingsState();
    });
  }
}
