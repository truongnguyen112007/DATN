import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
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
import '../../../../data/model/general_settings_model.dart';
import '../../../../data/model/privacy_settings_model.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../theme/app_styles.dart';
import 'general_settings_cubit.dart';
import 'general_settings_state.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends BaseState<GeneralSettingsPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final GeneralSettingsCubit _bloc;

  @override
  void initState() {
    _bloc = GeneralSettingsCubit();
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
            titleStr: AppLocalizations.of(context)!.settingsGeneral),
        body: generalSettingsListView(context));
  }

  @override
  bool get wantKeepAlive => true;

  Widget generalSettingsListView(BuildContext context) {
    return BlocBuilder<GeneralSettingsCubit, GeneralSettingsState>(
      bloc: _bloc,
      builder: (BuildContext context, state) {
        return ListView.builder(
          padding: EdgeInsets.only(top: contentPadding),
          itemCount: state.generalSettingsList.length,
          itemBuilder: (context, index) {
            return generalSettingsItemView(
                context, state.generalSettingsList.elementAt(index));
          },
        );
      },
    );
  }

  Widget generalSettingsItemView(
      BuildContext context, GeneralSettingsModel item) {
    return BlocBuilder<GeneralSettingsCubit, GeneralSettingsState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          return InkWell(
            child: Container(
              padding: EdgeInsets.only(left: 2.0*contentPadding),
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
                            style: googleFont.copyWith(fontSize: 10.w, fontWeight: FontWeight.w500, color: colorSubText)),
                        SizedBox(height: 10.h),
                        AppText(item.value,
                            style: googleFont.copyWith(fontSize: 22.w, fontWeight: FontWeight.w600, color: colorMainText))
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: colorDivider,
                  )
                ],
              ),
            ),
            onTap: () {
              _bloc.showGeneralSettingsOption(context, item);
            },
          );
        });
  }
}
