import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/locale_keys.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import 'app_text.dart';

enum TypeProfile { USER, ROUTER_SETTER, TRAINER }

extension TypeProfileExtension on TypeProfile {
  String get type {
    switch (this) {
      case TypeProfile.USER:
        return LocaleKeys.userTypeProfile.tr();
      case TypeProfile.ROUTER_SETTER:
        return LocaleKeys.routeSetterProfile.tr();
      case TypeProfile.TRAINER:
        return LocaleKeys.trainerProfile.tr();
      default:
        return LocaleKeys.userTypeProfile.tr();
    }
  }
}

class TypeProfileWidget extends StatefulWidget {
  final Function(TypeProfile) itemOnClick;
  final TypeProfile type;

  const TypeProfileWidget(
      {Key? key, required this.itemOnClick, required this.type})
      : super(key: key);

  @override
  State<TypeProfileWidget> createState() => _TypeProfileWidgetState();
}

class _TypeProfileWidgetState extends State<TypeProfileWidget> {
  var typeProfile = TypeProfile.USER;

  @override
  void initState() {
    typeProfile = widget.type;
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
                  padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
                  child: AppText(LocaleKeys.account_type.tr(),
                      style: typoW600.copyWith(
                          color: colorWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp))),
              itemContent(TypeProfile.USER),
              itemContent(TypeProfile.ROUTER_SETTER),
              itemContent(TypeProfile.TRAINER),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemContent(TypeProfile type) {
    return InkWell(
        child: Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Column(
            children: [
              Container(
                color: colorWhite,
                height: 0.1.h,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: AppText(
                  textAlign: TextAlign.center,
                  type.type,
                  style: typoW400.copyWith(
                      fontSize: 18.sp, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          setState(() {
            widget.itemOnClick.call(type);
            TypeProfile == type;
          });
        });
  }
}
