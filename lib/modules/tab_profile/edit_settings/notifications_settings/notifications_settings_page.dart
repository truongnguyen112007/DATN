import 'dart:convert';

import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/settings_item_widget.dart';
import 'package:base_bloc/data/model/notifications_settings_model.dart';
import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/notifications_settings/notifications_settings_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
import '../../../../data/globals.dart';
import 'notifications_settings_cubit.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsState();
}

class _NotificationsSettingsState extends BaseState<NotificationsSettingsPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final NotificationsSettingsCubit _bloc;

  @override
  void initState() {
    _bloc = NotificationsSettingsCubit();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        backgroundColor: colorGreyBackground,
        appbar: appBarWidget(
            context: context,
            titleStr: LocaleKeys.settingsNotifications),
        body: notificationsSettingsListView(context));
  }

  @override
  bool get wantKeepAlive => true;

  Widget notificationsSettingsListView(BuildContext context) {
    return BlocBuilder<NotificationsSettingsCubit, NotificationsSettingsState>(
      bloc: _bloc,
      builder: (BuildContext context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 2.0*contentPadding, left: 2.0*contentPadding),
          itemCount: state.notificationsSettingsList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.only(bottom: 2.0*contentPadding),
                child: AppText(
                    LocaleKeys.notif_push_notifications,
                    style: googleFont.copyWith(fontSize: 22.w, fontWeight: FontWeight.w600, color: colorMainText)),
              );
            }
            return notificationsSettingsItemView(
                context,
                state.notificationsSettingsList.elementAt(index - 1));
          },
        );
      },
    );
  }

  Widget notificationsSettingsItemView(
      BuildContext context, NotificationsSettingsModel item) {
    return BlocBuilder<NotificationsSettingsCubit, NotificationsSettingsState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          return Container(
            height: 60.h,
            child: Column(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                        child: AppText(item.type.title,
                            style: googleFont.copyWith(fontSize: 16.w, fontWeight: FontWeight.w400, color: colorMainText))),
                    Switch(
                        activeColor: colorPrimary,
                        activeTrackColor: colorPrimaryOrange40,
                        inactiveTrackColor: colorSubText,
                        value: item.isEnable,
                        onChanged: (val) {
                          item.isEnable = !item.isEnable;
                          state.notificationsSettingsList[state.notificationsSettingsList.indexWhere((element) => element.type == item.type)] = item;
                          _bloc.updateNotificationsSettingsState();
                        })
                  ],
                )),
                Divider(
                  thickness: 1.w,
                  color: colorDivider,
                )
              ],
            ),
          );
        });
  }
}
