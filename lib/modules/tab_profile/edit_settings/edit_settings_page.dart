import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/settings_item_widget.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_scalford.dart';
import '../../../components/appbar_widget.dart';
import 'edit_settings_cubit.dart';

class EditSettingsPage extends StatefulWidget {
  const EditSettingsPage({Key? key}) : super(key: key);

  @override
  State<EditSettingsPage> createState() => _EditSettingsState();
}

class _EditSettingsState extends BaseState<EditSettingsPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final EditSettingsCubit _bloc;

  @override
  void initState() {
    _bloc = EditSettingsCubit();
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
        appbar: appBarWidget(context: context, titleStr: LocaleKeys.settings),
        body: settingsListView());
  }

  @override
  bool get wantKeepAlive => true;

  Widget settingsListView() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(top: contentPadding),
          itemCount: _bloc.settingsList(context).length,
          itemBuilder: (context, index) {
            return SettingsItemWidget(
                setting: _bloc.settingsList(context)[index],
                onSelectedItem: () {
                  SettingsModel item = _bloc.settingsList(context)[index];
                  switch (item.type) {
                    case SettingsItemType.ACCOUNT:
                      _bloc.openAccountPage(context);
                      break;
                    case SettingsItemType.NOTIFICATIONS:
                      _bloc.openNotificationsSettingsPage(context);
                      break;
                    case SettingsItemType.PRIVACY:
                      _bloc.openPrivacySettingsPage(context);
                      break;
                    case SettingsItemType.GENERAL:
                      _bloc.openGeneralSettingsPage(context);
                      break;
                    default:
                      print(item.type.title);
                  }
                });
          },
        );
      },
    );
  }
}
