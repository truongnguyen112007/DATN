import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/notifications_settings_model.dart';
import 'notifications_settings_state.dart';

class NotificationsSettingsCubit extends Cubit<NotificationsSettingsState> {
  NotificationsSettingsCubit() : super(NotificationsSettingsState(status: NotificationsSettingsStatus.initial)) {
    if (state.status == NotificationsSettingsStatus.initial) {
      state.initNotificationsSettingsList();
    }
  }

  void updateNotificationsSettingState() {
    emit(state.newState());
  }

}