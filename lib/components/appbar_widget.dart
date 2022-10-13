import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../router/router_utils.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

PreferredSizeWidget appBarWidget(
        {required BuildContext context,
        Widget? leading,
        Widget? title,
        double? titleSpacing = 0,
        double? landingWidth = 56,
        double? toolbarHeight,
        String? titleStr,
        Color? backgroundColor,
        List<Widget>? action,
        bool isHideBottomBar = false,
        bool automaticallyImplyLeading = true}) =>
    AppBar(
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: landingWidth,
      centerTitle: false,
      titleSpacing: titleSpacing,
      elevation: 0,
      leading: leading ??
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: colorText65,
            ),
            onPressed: () =>
                RouterUtils.pop(context, isHideBottomBar: isHideBottomBar),
          ),
      title: title ??
          AppText(
            titleStr ?? '',
            style: googleFont.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: colorText0.withOpacity(0.87)),
          ),
      backgroundColor: backgroundColor ?? colorBlack,
      actions: action,
    );
