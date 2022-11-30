import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/locale_keys.dart';

class FeatureUnderWidget extends StatelessWidget {
  const FeatureUnderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      body: Center(
        child: AppText(
          LocaleKeys.thisFeatureIsUnder.tr(),
          textAlign: TextAlign.center,
          style: googleFont.copyWith(color: colorWhite,fontSize: 20.sp),
        ),
      ),
    );
  }
}
