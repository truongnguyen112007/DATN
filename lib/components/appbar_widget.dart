import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../data/globals.dart';
import '../gen/assets.gen.dart';
import '../router/router_utils.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

PreferredSizeWidget appBarWidget(
        {required BuildContext context,
        Widget? leading,
        Widget? title,
        double? titleSpacing = 16,
        double? leadingWidth = 56,
        double? toolbarHeight,
        String? titleStr,
        Color? backgroundColor,
        List<Widget>? action,
        bool isHideBottomBar = false,
        VoidCallback? onPressed,
        bool automaticallyImplyLeading = true}) =>
    AppBar(
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      centerTitle: false,
      titleSpacing: titleSpacing,
      elevation: 0,
      leading: leading ??
          IconButton(
            icon: Assets.png.icArrowBack.image(width: 16.w, height: 16.w),
            onPressed: () {
              if (onPressed != null) {
                onPressed.call();
                return;
              }
              RouterUtils.pop(context, isHideBottomBar: isHideBottomBar);
            },
          ),
      title: title ??
          AppText(
            titleStr ?? '',
            style: typoW600.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: colorText0.withOpacity(0.87)),
          ),
      backgroundColor: backgroundColor ?? colorBlack,
      actions: action,
    );

PreferredSizeWidget homeAppbar(BuildContext context, {required Function onClickSearch, required Function onClickNotification, required Function onClickJumpToTop,required Widget widget}) => appBarWidget(
    leading: const SizedBox(),
    backgroundColor: colorMainBackground,
    leadingWidth: contentPadding,
    context: context,
    title: InkWell(
      splashColor: colorTransparent,
      highlightColor: colorTransparent,
      onTap: () => onClickJumpToTop(),
      child: widget
    ),
    action: [
      IconButton(
        onPressed: () => onClickSearch(), // _bloc.searchOnclick(context),
        icon: SvgPicture.asset(
          Assets.svg.search,
          color: colorSubText,
        ),
      ),
      InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 10.w,right: contentPadding),
          child: Badge(
            gradient: LinearGradient(colors: [
              colorYellow70,
              colorPrimary,
              colorPrimary.withOpacity(0.65),
            ]),
            padding: const EdgeInsets.all(2),
            position: BadgePosition.topEnd(top: 11.h, end: 3.h),
            toAnimate: false,
            badgeContent: AppText(
              ' ',
              style: typoSmallTextRegular.copyWith(
                  fontSize: 9.sp, color: colorWhite),
            ),
            child: SvgPicture.asset(
              Assets.svg.notification,
              color: colorSubText,
            ),
          ),
        ),
        onTap: () => onClickNotification(),
      ),
    ]);