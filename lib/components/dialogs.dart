import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/components/login_dialog.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../modules/home/home_page.dart';
import '../modules/tab_profile/edit_settings/edit_settings_state.dart';
import '../router/router_utils.dart';
import '../utils/storage_utils.dart';
import '../utils/toast_utils.dart';
import 'app_text.dart';

class Dialogs {
  static final GlobalKey<State> _keyLoader = GlobalKey<State>();

  static Future<void>? showLoadingDialog(BuildContext? context) {
    if (context == null) {
      return null;
    }
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              key: _keyLoader,
              backgroundColor: Colors.transparent,
              children: const <Widget>[
                Center(
                  child: CircularProgressIndicator(
                      color: colorOrange110, strokeWidth: 4.0),
                )
              ],
            ),
          );
        });
  }

  static Future<void> hideLoadingDialog() async {
    await Future.delayed(
        const Duration(milliseconds: 200),
        () => Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
            .pop());
  }

  static Future<void>? showWidgetDialog(BuildContext context,{required VoidCallback callback,String? text}) {
    return showDialog<void>(
        context: context,
        barrierColor: colorBlack.withOpacity(0.85),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              key: _keyLoader,
              backgroundColor: Colors.transparent,
              children: <Widget>[
                Column(
                  children: [
                    AppText(
                      text!,
                      style:
                      typoW600.copyWith(color: colorWhite, fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        GradientButton(
                            height: 36.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient:
                                Utils.backgroundGradientOrangeButton()),
                            onTap: callback,
                            widget: Center(
                                child: AppText(
                                  'Yes',
                                  style: typoW600.copyWith(color: colorBlack,fontSize: 15.sp),
                                )),
                            borderRadius: BorderRadius.circular(18)),
                        SizedBox(
                          width: 20.w,
                        ),
                        AppButton(
                          title: 'Cancel',
                          textStyle: typoW600.copyWith(
                              color: colorBlack, fontSize: 15.sp),
                          onPress: () {
                            hideLoadingDialog();
                          },
                          width: 130.w,
                          height: 36.h,
                          backgroundColor: colorWhite,
                          borderRadius: 18,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }


  static Future<void>? showLogOutDiaLog(BuildContext context,{required VoidCallback callback}) {
    return showDialog<void>(
        context: context,
        barrierColor: colorBlack.withOpacity(0.85),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              key: _keyLoader,
              backgroundColor: Colors.transparent,
              children: <Widget>[
                Column(
                  children: [
                    AppText(
                      'Are you sure want to log out ?',
                      style:
                          typoW600.copyWith(color: colorWhite, fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        GradientButton(
                            height: 36.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient:
                                    Utils.backgroundGradientOrangeButton()),
                            onTap: callback,
                            widget: Center(
                                child: AppText(
                              'Yes',
                              style: typoW600.copyWith(color: colorBlack,fontSize: 15.sp),
                            )),
                            borderRadius: BorderRadius.circular(18)),
                        SizedBox(
                          width: 20.w,
                        ),
                        AppButton(
                          title: 'Cancel',
                          textStyle: typoW600.copyWith(
                              color: colorBlack, fontSize: 15.sp),
                          onPress: () {
                            hideLoadingDialog();
                          },
                          width: 130.w,
                          height: 36.h,
                          backgroundColor: colorWhite,
                          borderRadius: 18,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  static Future<void>? showLogInDiaLog(BuildContext context,
      {required VoidCallback loginOnClick}) {
    return showDialog<void>(
        context: context,
        barrierColor: colorBlack.withOpacity(0.85),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              key: _keyLoader,
              backgroundColor: Colors.transparent,
              children:  <Widget>[
                LoginDialog(loginOnClick: () async {
                  await Dialogs.hideLoadingDialog();
                  loginOnClick.call();
                }),
              ],
            ),
          );
        });
  }
}
