import 'package:flutter/material.dart';
import '../router/router_utils.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

PreferredSizeWidget appBarWidget(
        {required BuildContext context,
        Widget? leading,
        Widget? title,
        String? titleStr,
        List<Widget>? action}) =>
    AppBar(
      centerTitle: false,
      elevation: 0,
      leading: leading ??
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: colorText65,
            ),
            onPressed: () => RouterUtils.pop(context),
          ),
      title: title ??
          AppText(
            titleStr ?? '',
            style: typoLargeTextRegular.copyWith(color: colorText65),
          ),
      backgroundColor: colorBlack,
      actions: action,
    );
