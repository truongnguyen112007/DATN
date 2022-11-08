import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../theme/app_styles.dart';

class AppNotDataWidget extends StatelessWidget {
  final String? message;

  const AppNotDataWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        message ?? LocaleKeys.not_data,
        style: typoSmallTextRegular.copyWith(color: colorText0.withOpacity(0.87)),
      ),
    );
  }
}
