import 'dart:ffi';

import 'package:base_bloc/data/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/globals.dart';
import '../localizations/app_localazations.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';
import '../utils/app_utils.dart';
import 'app_text.dart';

double _avatarSize = 32.w;

Widget itemNotificationWidget(NotificationModel? item, bool isInvitation, {required Function onClickAddToFriends, required Function onClickReject}) {
  return Container(
      padding: EdgeInsets.only(
          top: contentPadding,
          bottom: contentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: _avatarSize / 2.0,
            backgroundColor: Colors.transparent,
            child: ClipOval(
                child: Image.network(
              item?.image ?? '',
              fit: BoxFit.cover,
              width: _avatarSize,
              height: _avatarSize,
            )),
          ),
          SizedBox(width: contentPadding),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                AppText(item?.title ?? '',
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 14.w,
                        fontWeight: FontWeight.w700)),
                SizedBox(width: contentPadding / 2.0),
                AppText(item?.date ?? '',
                    style: googleFont.copyWith(
                        color: colorSubText,
                        fontSize: 12.w,
                        fontWeight: FontWeight.w400))
              ],
            ),
            AppText(item?.content ?? '',
                style: googleFont.copyWith(
                    color: colorSubText,
                    fontSize: 12.w,
                    fontWeight: FontWeight.w400)),
            SizedBox(height: 2.w),
            if (isInvitation) invitationActionsWidget(onClickAddToFriends: onClickAddToFriends, onClickReject: onClickReject)
          ])
        ],
      ));
}

Widget invitationActionsWidget({required Function onClickAddToFriends, required Function onClickReject}) {
  return Container(
    child: Row(
      children: [
        Container(
          height: 36.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.w),
                gradient: Utils.backgroundGradientOrangeButton()),
            child: TextButton(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Text(LocaleKeys.add_to_friends,
                      style: googleFont.copyWith(
                          color: colorMainText,
                          fontSize: 14.w,
                          fontWeight: FontWeight.w600)),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.transparent),
                onPressed: () => onClickAddToFriends()),
          ),
        ),
        SizedBox(width: contentPadding),
        Container(
          height: 36.w,
          child: TextButton(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Text(LocaleKeys.reject,
                    style: googleFont.copyWith(
                        color: colorMainText,
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400)),
              ),
              style: TextButton.styleFrom(
                primary: colorMainText,
                onSurface: colorMainBackground,
                side: BorderSide(color: colorMainText, width: 1.w),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.w))),
              ),
              onPressed: () => onClickReject()),
        ),
      ],
    ),
  );
}

Widget titleHeaderWidget(String title) => Padding(
      padding: EdgeInsets.only(
          left: contentPadding, top: contentPadding, bottom: 3.w),
      child: AppText(
        title.toUpperCase(),
        style: typoW600.copyWith(fontSize: 10.sp, color: colorMainText),
      ),
    );
