import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/locale_keys.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

enum VisibilityType { PUBLIC, FRIENDS, PRIVATE }

extension VisibilityTypeExtension on VisibilityType {
  String get type {
    switch (this) {
      case VisibilityType.PUBLIC:
        return LocaleKeys.public.tr();
      case VisibilityType.FRIENDS:
        return LocaleKeys.friends.tr();
      case VisibilityType.PRIVATE:
        return LocaleKeys.private.tr();
      default:
        return LocaleKeys.friend.tr();
    }
  }
}

class VisibilityRouteWidget extends StatefulWidget {
  final Function(VisibilityType) itemOnClick;
  final VisibilityType type;

  const VisibilityRouteWidget(
      {Key? key, required this.itemOnClick, required this.type})
      : super(key: key);

  @override
  State<VisibilityRouteWidget> createState() => _VisibilityRouteWidgetState();
}

class _VisibilityRouteWidgetState extends State<VisibilityRouteWidget> {
  var visibilityType = VisibilityType.FRIENDS;

  @override
  void initState() {
    visibilityType = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorShowActionDialog,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Container(
                  width: 70.w, height: 1.h, color: colorWhite.withOpacity(0.7)),
              Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  child: AppText(LocaleKeys.visibility.tr(),
                      style: typoW600.copyWith(
                          color: colorWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp))),
              itemContent(VisibilityType.PRIVATE),
              itemContent(VisibilityType.FRIENDS),
              itemContent(VisibilityType.PUBLIC),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemContent(VisibilityType type) {
    return InkWell(
        child: Column(
          children: [
            Container(
              color: colorWhite,
              height: 0.1.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 30.w, top: 12.h, bottom: 12.h, right: 50.w),
              child: Row(
                children: [
                  Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: visibilityType == type
                                ? colorOrange90
                                : colorGrey50,
                            width: 1.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Visibility(
                          visible: visibilityType == type ? true : false,
                          child: const Center(
                              child: Icon(Icons.check,
                                  color: colorOrange90, size: 15)))),
                  Expanded(
                      child: AppText(
                          textAlign: TextAlign.center,
                          type.type,
                          style: typoW400.copyWith(
                              color: visibilityType == type
                                  ? colorOrange90
                                  : colorWhite,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400)))
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            widget.itemOnClick.call(type);
            visibilityType == type;
          });
        });
  }
}
