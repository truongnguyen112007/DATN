import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/model/settings_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_settings_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsItemWidget extends StatelessWidget {
  final SettingsModel setting;
  final VoidCallback onSelectedItem;

  SettingsItemWidget({required this.setting, required this.onSelectedItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 15.0, left: 0.0, bottom: 15.0, right: 0.0),
      child: InkWell(
        onTap: () { this.onSelectedItem(); },
        child: Container(
          padding:
          EdgeInsets.only(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0),
          child: Row(
            children: [
              setting.type.icon.image(
                  height: 24.h,
                  width: 24.w,
                color: Colors.white70
              ),
              SizedBox(width: 20.w),
              AppText(
                setting.type.title,
                style: TextStyle(color: Colors.white70, fontSize: 20.0),
              )
            ],
          ),
        )
      )
    );
  }

}
