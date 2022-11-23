import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../gen/assets.gen.dart';

class AppLikeButton extends StatefulWidget {
  const AppLikeButton({Key? key}) : super(key: key);

  @override
  State<AppLikeButton> createState() => _AppLikeButtonState();
}

class _AppLikeButtonState extends State<AppLikeButton> {
  bool isLiked = false;
  int count = 5;

  Widget actionWidget(Widget title, String content) => SizedBox(
        height: 38.h,
        child: Column(
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.topLeft,
              child: title,
            )),
            AppText(
              content,
              style: typoSuperSmallTextRegular.copyWith(
                  fontSize: 11.sp, color: colorText0.withOpacity(0.87)),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isLiked = !isLiked;
        count = isLiked == true ? count + 1 : count - 1;
        setState(() {});
      },
      child: SizedBox(
        height: 38.h,
        child: Column(
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.topLeft,
              child: isLiked
                  ? Image.asset(
                      Assets.png.liked.path,
                      width: 18.w,
                    )
                  : SvgPicture.asset(
                      Assets.svg.like,
                      width: 18.w,
                    ),
            )),
            AppText(
              '$count ${LocaleKeys.likes}',
              style: typoSuperSmallTextRegular.copyWith(
                  fontSize: 11.sp, color: colorText0.withOpacity(0.87)),
            )
          ],
        ),
      ),
    );
  }
}
