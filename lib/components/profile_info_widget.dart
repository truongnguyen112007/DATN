import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/profile_model.dart';
import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../localization/locale_keys.dart';
import '../theme/colors.dart';
import 'app_text.dart';

class ProfileInfoWidget extends StatelessWidget {
  final UserProfileModel profileModel;
  final VoidCallback onPressEditProfile;

  const ProfileInfoWidget(
      {Key? key, required this.profileModel, required this.onPressEditProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: colorMainBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 2 * contentPadding,
                  left: 2 * contentPadding,
                  right: 2 * contentPadding),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      profileModel.photo ?? '',
                      fit: BoxFit.cover,
                      width: 65.w ,
                      height: 65.h ,
                    ),
                  ),
                  SizedBox(width: 2 * contentPadding),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      AppText(
                          "${profileModel.firstName ?? ''} ${profileModel.lastName ?? ''}",
                          maxLine: 1,
                          style: googleFont.copyWith(
                              color: colorMainText,
                              fontSize: 22.w,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis)),
                      AppText(profileModel.role ?? '',
                          style: googleFont.copyWith(
                              color: colorSubText,
                              fontSize: 14.w,
                              fontWeight: FontWeight.w400))
                    ]),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(color: colorWhite.withOpacity(0.12), height: 1.h),
            _userCountInfoWidget(context),
            _userActionsWidget(context)
          ],
        ),
      ),
    );
  }

  /* Show user count info: passed, dessigned, friends */
  Widget _userCountInfoWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 2 * contentPadding,
            left: 2 * contentPadding,
            right: 2 * contentPadding),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.countPassed.tr(),
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 10.w,
                        fontWeight: FontWeight.w600)),
                AppText("32",
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 24.w,
                        fontWeight: FontWeight.w700))
              ],
            ),
            SizedBox(width: 40.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.countDesigned.tr(),
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 10.w,
                        fontWeight: FontWeight.w600)),
                AppText("12",
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 24.w,
                        fontWeight: FontWeight.w700))
              ],
            ),
            SizedBox(width: 40.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.countFriends.tr(),
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 10.w,
                        fontWeight: FontWeight.w600)),
                AppText("24",
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 24.w,
                        fontWeight: FontWeight.w700))
              ],
            )
          ],
        ));
  }

  /* Custom actions: Edit settings, Add/Remove friends, Message */
  Widget _userActionsWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 2 * contentPadding,
          left: 2 * contentPadding,
          right: 2 * contentPadding),
      child: TextButton(
          style: TextButton.styleFrom(
            primary: colorMainText,
            onSurface: colorMainBackground,
            side: BorderSide(color: colorMainText, width: 1.5.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.w))),
          ),
          onPressed: () => onPressEditProfile(),
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Text(LocaleKeys.editSettings.tr(),
                style: googleFont.copyWith(
                    color: colorMainText,
                    fontSize: 14.w,
                    fontWeight: FontWeight.w400)),
          )),
    );
  }
}
