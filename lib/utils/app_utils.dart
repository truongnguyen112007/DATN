import 'dart:math';

import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/data/model/general_action_sheet_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/privacy_settings/privacy_settings_cubit.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../base/hex_color.dart';
import '../components/app_text.dart';
import '../data/globals.dart';
import '../data/model/privacy_settings_model.dart';
import '../data/model/routes_model.dart';
import '../gen/assets.gen.dart';
import '../localizations/app_localazations.dart';
import '../modules/playlist/playlist_cubit.dart';
import '../theme/app_styles.dart';
import '../theme/colors.dart';

class Utils {
  static var METHOD_CHANNEL = "METHOD_CALL_NATIVE";
  static var eventBus = EventBus();

  static fireEvent(dynamic model) => eventBus.fire(model);

  static String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';

    params.forEach((key, value) {
      if (inRecursion) {
        key = '[$key]';
      }
      if (value is String || value is int || value is double || value is bool) {
        query += '$prefix$key=$value';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    query = query.replaceFirst(RegExp('&'), '?');
    return query;
  }

  static void hideKeyboard(BuildContext? context) {
    if (context != null) FocusScope.of(context).requestFocus(FocusNode());
  }

  static List<String> getDaysOfWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat('yyyy-MM-dd ${DateFormat.WEEKDAY}')
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static DateTime findFirstDateOfTheWeek() {
    var dateTime = DateTime.now();
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek() {
    var dateTime = DateTime.now();
    return DateTime.now()
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static String convertTimeStampToYYMMDD(int timeStamp) {
    var dateTime =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp, isUtc: true).toLocal();
    return '${dateTime.year}-${dateTime.month.toString().length == 1 ? '0' + dateTime.month.toString() : dateTime.month}-${dateTime.day.toString().length == 1 ? '0' + dateTime.day.toString() : dateTime.day}';
  }

  static bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static List<Color> getBackgroundColor(String value) {
    switch (value) {
      case '4':
        return [HexColor('005926'), HexColor('005926')];
      case '5A':
        return [
          HexColor('D17800'),
          HexColor('D17800'),
          HexColor('005926'),
          HexColor('005926'),
        ];
      case '5':
        return [colorOrange80, colorGreen70, colorGreen70];
      case '6':
        return [
          HexColor('D17800'),
          HexColor('D17800').withOpacity(0.6),
          HexColor('005926'),
          HexColor('005926')
        ];
      case '7':
        return [HexColor('D11D00'), HexColor('D17800'), HexColor('D17800')];
      case '8':
        return [
          HexColor('D17800'),
          HexColor('D17800'),
          HexColor('005926'),
          HexColor('005926')
        ];
      case '5':
        return [
          HexColor('A77208'),
          HexColor('005926'),
          HexColor('005926'),
        ];
      default:
        return [
          colorRed100,
          colorRed100,
        ];
    }
  }

  static void snackBarMessage(String message,
      {Color? backgroundColor, SnackPosition? position, Color? colorText}) {
    Get.snackbar("LocaleKeys.notify.tr", message,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: backgroundColor ?? colorBackgroundWhite,
        colorText: colorText ?? colorText100,
        animationDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 2),
        snackPosition: position ?? SnackPosition.BOTTOM);
  }

  static bool validatePassword(String value) {
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static String convertTimeToDDMMHH(DateTime? time) {
    if (time == null) return '';
    var result = DateFormat('dd-MM-yyyy').format(time);
    return result.toString().split(' ')[0];
  }

  static String convertTimeToYYMMDDFromStr(String time) {
    var result = time.split('-');
    return '${result[2]}-${result[1]}-${result[0]}';
  }

  static String getFullTimeFromStr(String time) {
    var result = time.split(':');
    return "${result[0]}:${(result[1].length == 1 ? "0" + result[1] : result[1])}";
  }

  static String getFullHoursFromStr(String time) {
    var result = time.split(':');
    return "${(result[0].length == 1 ? "0" + result[0] : result[0])}:${(result[1].length == 1 ? "0" + result[1] : result[1])}";
  }

  static String convertTimeToYYMMDDFromDateTime(DateTime time) =>
      DateFormat('yyyy-MM-dd').format(time).toString();

  static String convertTimeToDDMMYYFromStr(String time) =>
      DateFormat('dd-MM-yyyy').parse(time).toString();

  static String convertTimeToDDMMYYFromDateTime(DateTime time) =>
      DateFormat('dd-MM-yyyy').format(time).toString();

  static String convertTimeToMMMDDYYYYHOUR(DateTime? time) =>
      DateFormat('MMM dd yyyy, HH:MM')
          .format(time ?? DateTime.now())
          .toString();

  static String convertTimeToMMMDDYYYY(DateTime? time) =>
      DateFormat('MMM dd yyyy').format(time ?? DateTime.now()).toString();

  static String convertTimeToDDMMYYHHMMFromDateTime(DateTime time) =>
      DateFormat('dd/MM/yyyy - hh:mm').format(time).toString();

  static String convertTimeToYYHHFromDateTime(DateTime time) =>
      DateFormat('hh:mm').format(time).toString();

  static String convertTimeToMMMYYDD(DateTime time) =>
      DateFormat('dd - MMM').format(time).toString();

  static String convertHoursFromStr(String? input) {
    if (input == null || input.isEmpty) return '';
    var time = parseTimeOfDay(input);
    var hour = time.hour.toString().length == 1
        ? "0" + time.hour.toString()
        : time.hour.toString();
    var minute = time.minute.toString().length == 1
        ? "0" + time.minute.toString()
        : time.minute.toString();
    return "$hour:$minute";
  }

  static TimeOfDay parseTimeOfDay(String t) {
    DateTime dateTime = DateFormat("HH:mm").parse(t);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String reformatDateToMMMDDYYFromStr(String dateTime) {
    return DateFormat('MMM DD YYYY').parse(dateTime).toString();
  }

  static DateTime convertStringToDate(String date) =>
      DateFormat('yy-MM-dd').parse(date);

  static String convertDateToMMYYYY(DateTime date) =>
      DateFormat('MM/yyyy').format(date);

  static String formatMoney(int? money) =>
      NumberFormat('#,###,###,#,###,###,###', 'vi').format(money ?? 0);

  static String randomTag() => Random().nextInt(100).toString();

  static void showActionDialog(
      BuildContext context, Function(ItemAction) callBack) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (x) => Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(contentPadding),
                  decoration: BoxDecoration(
                    color: colorBlack.withOpacity(0.75),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: contentPadding,
                      ),
                      itemAction(
                          Assets.svg.moveToTop,
                          AppLocalizations.of(context)!.moveToPlaylist,
                          ItemAction.MOVE_TO_TOP,
                          () => callBack.call(ItemAction.MOVE_TO_TOP)),
                      itemAction(
                          Assets.svg.addToPlayList,
                          AppLocalizations.of(context)!.addToPlaylist,
                          ItemAction.ADD_TO_PLAYLIST,
                          () => callBack.call(ItemAction.ADD_TO_PLAYLIST)),
                      itemAction(
                          Assets.svg.removeFromPlaylist,
                          AppLocalizations.of(context)!.removeFromPlaylist,
                          ItemAction.REMOVE_FROM_PLAYLIST,
                          () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                      itemAction(
                          Assets.svg.liked,
                          AppLocalizations.of(context)!.addToFavourite,
                          ItemAction.ADD_TO_FAVOURITE,
                          () => callBack.call(ItemAction.ADD_TO_FAVOURITE)),
                      itemAction(
                          Assets.svg.like,
                          AppLocalizations.of(context)!.removeFromFavorite,
                          ItemAction.REMOVE_FROM_PLAYLIST,
                          () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                      itemAction(
                          Assets.svg.share,
                          AppLocalizations.of(context)!.share,
                          ItemAction.SHARE,
                          () => callBack.call(ItemAction.SHARE)),
                      itemAction(
                          Assets.svg.copy,
                          AppLocalizations.of(context)!.copy,
                          ItemAction.COPY,
                          () => callBack.call(ItemAction.COPY)),
                      itemAction(
                          Assets.svg.edit,
                          AppLocalizations.of(context)!.edit,
                          ItemAction.EDIT,
                          () => callBack.call(ItemAction.EDIT)),
                      itemAction(
                          Assets.svg.delete,
                          AppLocalizations.of(context)!.delete,
                          ItemAction.DELETE,
                          () => callBack.call(ItemAction.DELETE)),
                    ],
                  ),
                )
              ],
            ));
  }

  static Widget itemAction(String icon, String text, ItemAction action,
      VoidCallback filterCallBack) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Row(
          children: [
            SizedBox(
              width: 22.w,
              height: 22.w,
              child: SvgPicture.asset(icon),
            ),
            SizedBox(
              width: 40.w,
            ),
            AppText(
              text,
              style: typoW400.copyWith(
                  fontSize: 16,
                  color: colorText0.withOpacity(
                      0.87)) /*typoSuperSmallTextRegular.copyWith(color: colorText0)*/,
            )
          ],
        ),
      ),
      onTap: () => filterCallBack.call(),
    );
  }

  static String convertDateTimeToEEE(DateTime dateTime) =>
      DateFormat('EEE').format(dateTime);

  static String convertDateTimeToEEEDDMMM(DateTime dateTime) =>
      DateFormat('EEE, d MMMM').format(dateTime);

  static String convertDateTimeToDD(DateTime dateTime) =>
      DateFormat('dd').format(dateTime);

  static LinearGradient backgroundGradientOrangeButton(
          {AlignmentGeometry? begin, AlignmentGeometry? end}) =>
      LinearGradient(
          begin: begin ?? Alignment.topCenter,
          end: end ?? Alignment.bottomCenter,
          colors: [
            HexColor('FF9300'),
            HexColor('FF5A00'),
            HexColor('FF5A00'),
          ]);
}

// Custom dialog action sheet for Settings screen
class UtilsExtension extends Utils {
  static void showGeneralOptionActionDialog(
      BuildContext context,
      List<GeneralActionSheetModel> actionSheetModels,
      Function(GeneralActionSheetModel) callBack) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (x) => Wrap(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF212121),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: contentPadding,
                      ),
                      ...actionSheetModels.map((item) =>
                          generalItemAction(item.icon, item.value, () {
                            callBack.call(item);
                            Navigator.pop(context);
                          })),
                      SizedBox(
                        height: 40.h,
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  static Widget generalItemAction(
      Image? icon, String text, VoidCallback callback) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Row(
          children: [
            SizedBox(
              width: 7.h,
            ),
            if (icon != null) icon,
            SizedBox(
              width: 20.h,
            ),
            AppText(
              text,
              style: typoNormalTextRegular.copyWith(color: Colors.white70),
            )
          ],
        ),
      ),
      onTap: () => callback.call(),
    );
  }
}
