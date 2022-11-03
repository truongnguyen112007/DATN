import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_settings_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsItemWidget extends StatelessWidget {
  final SettingsModel setting;
  final VoidCallback onSelectedItem;

  SettingsItemWidget({required this.setting, required this.onSelectedItem});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 2.0 * contentPadding,
            left: 0.0,
            bottom: 2.0 * contentPadding,
            right: 0.0),
        child: InkWell(
            onTap: () {
              this.onSelectedItem();
            },
            child: Container(
              padding: EdgeInsets.only(
                  top: 0.0,
                  left: 2.0 * contentPadding,
                  bottom: 0.0,
                  right: 2.0 * contentPadding),
              child: Row(
                children: [
                  Container(
                      child: SvgPicture.asset(setting.type.icon,
                          color: setting.color ?? colorMainText),
                      width: 18.w,
                      height: 18.w),
                  SizedBox(width: 3.0 * contentPadding),
                  AppText(
                    setting.type.title,
                    style: googleFont.copyWith(
                        color: setting.color ?? colorMainText,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )));
  }
}
