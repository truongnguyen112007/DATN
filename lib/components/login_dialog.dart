import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localization/locale_keys.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../utils/app_utils.dart';
import 'gradient_button.dart';

class LoginDialog extends StatelessWidget {
  final VoidCallback loginOnClick;

  const LoginDialog({Key? key, required this.loginOnClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: HexColor('4B4A4A').withOpacity(0.44)),
      padding: EdgeInsets.all(contentPadding * 3),
      child: Column(
        children: [
          AppText(LocaleKeys.you_need_login_to_use_this_service.tr(),
              style: typoW600.copyWith(fontSize: 16)),
          const SizedBox(height: 30),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: GradientButton(
                      height: 30.h,
                      borderRadius: BorderRadius.circular(20),
                      decoration: BoxDecoration(
                          gradient: Utils.backgroundGradientOrangeButton(),
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () => loginOnClick.call(),
                      isCenter: true,
                      widget: AppText(
                        LocaleKeys.login.tr(),
                        style: typoW600.copyWith(
                            fontSize: 12.sp, color: colorText100),
                      ))),
              const SizedBox(width: 20),
              Expanded(
                  child: GradientButton(
                      height: 30.h,
                      borderRadius: BorderRadius.circular(20),
                      decoration: BoxDecoration(
                          color: colorWhite,
                          border: Border.all(color: colorOrange100),
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () => Navigator.pop(context),
                      isCenter: true,
                      widget: AppText(
                        LocaleKeys.cancel.tr(),
                        style: typoW600.copyWith(
                            fontSize: 12.sp, color: colorText100),
                      )))
            ],
          )
        ],
      ),
    );
  }
}
