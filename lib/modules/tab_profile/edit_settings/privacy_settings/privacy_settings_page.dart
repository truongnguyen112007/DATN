import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/privacy_settings/privacy_setting_state.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/privacy_settings/privacy_settings_cubit.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../components/app_scalford.dart';
import '../../../../components/appbar_widget.dart';
import '../../../../data/model/privacy_settings_model.dart';
import '../../../../gen/assets.gen.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends BaseState<PrivacySettingsPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final PrivacySettingsCubit _bloc;

  @override
  void initState() {
    _bloc = PrivacySettingsCubit();
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
            titleStr: LocaleKeys.settingsPrivacy),
        body: privacySettingsListView(context));
  }

  @override
  bool get wantKeepAlive => true;

  Widget privacySettingsListView(BuildContext context) {
    return BlocBuilder<PrivacySettingsCubit, PrivacySettingsState>(
      bloc: _bloc,
      builder: (BuildContext context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 10.0),
          itemCount: state.privacySettingsList.length,
          itemBuilder: (context, index) {
            return privacySettingsItemView(
                context, state.privacySettingsList.elementAt(index));
          },
        );
      },
    );
  }

  Widget privacySettingsItemView(
      BuildContext context, PrivacySettingsModel item) {
    return BlocBuilder<PrivacySettingsCubit, PrivacySettingsState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          return InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 15.0),
              height: 100.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(item.type.title,
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            item.value.icon.image(
                                width: 20.w, height: 20.h, color: Colors.white70),
                            SizedBox(width: 10.0),
                            AppText(item.value.title,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600))
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.7,
                    color: Colors.white38,
                  )
                ],
              ),
            ),
            onTap: () {
              _bloc.showPrivacyOption(context, item);
            },
          );
        });
  }
}
