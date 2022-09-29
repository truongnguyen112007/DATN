import 'dart:convert';

import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/settings_item_widget.dart';
import 'package:base_bloc/data/model/notifications_settings_model.dart';
import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/notifications_settings/notifications_settings_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
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
        backgroundColor: colorBlack20,
        appbar: appBarWidget(
            context: context,
            titleStr: AppLocalizations.of(context)!.settingsNotifications),
        body: notificationsSettingsListView(context));
  }

  @override
  bool get wantKeepAlive => true;

  Widget notificationsSettingsListView(BuildContext context) {
    return BlocBuilder<NotificationsSettingsCubit, NotificationsSettingsState>(
      bloc: _bloc,
      builder: (BuildContext context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 15.0, left: 15.0),
          itemCount: state.notificationsSettingsList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.only(bottom: 15.w),
                child: AppText(
                    AppLocalizations.of(context)!.notif_push_notifications,
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w800,
                        fontSize: 24.0)),
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
                        child: AppText(item.type.title(context),
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600))),
                    Switch(
                        activeColor: colorPrimaryOrange100,
                        activeTrackColor: colorPrimaryOrange40,
                        inactiveTrackColor: colorGrey70,
                        value: item.isEnable,
                        onChanged: (val) {
                          item.isEnable = !item.isEnable;
                          state.notificationsSettingsList[state.notificationsSettingsList.indexWhere((element) => element.type == item.type)] = item;
                          _bloc.updateNotificationsSettingsState();
                        })
                  ],
                )),
                Divider(
                  height: 0.7,
                  color: Colors.white38,
                )
              ],
            ),
          );
        });
  }
}
