import 'dart:async';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/modules/tab_climb/tab_climb_cubit.dart';
import 'package:base_bloc/modules/tab_climb/tab_climb_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../components/app_text.dart';
import '../../components/check_login.dart';
import '../../components/gradient_button.dart';
import '../../data/globals.dart';
import '../../data/model/places_model.dart';
import '../../gen/assets.gen.dart';
import '../../localizations/app_localazations.dart';
import '../../theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

class TabClimb extends StatefulWidget {
  const TabClimb({Key? key}) : super(key: key);

  @override
  State<TabClimb> createState() => _TabClimbState();
}

class _TabClimbState extends State<TabClimb> with TickerProviderStateMixin {
  var isShowMap = false;

  late TabClimbCubit _bloc;

  @override
  void initState() {
    _bloc = TabClimbCubit();
    Timer.periodic(const Duration(milliseconds: 3000),
        Platform.isAndroid ? _bloc.androidGetBlueLack : _bloc.iosGetBlueState);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      AppScaffold(
      backgroundColor: colorGrey90,
      appbar: homeAppbar(context,
          onClickSearch: () {
              _bloc.onClickSearch(context);
          },
          onClickNotification: () {
        _bloc.onClickNotification(context);
          },
          onClickJumpToTop: () {},
          widget: AppText(
            LocaleKeys.climb,
            style: googleFont.copyWith(color: colorWhite),
          )),
      body:
      BlocBuilder(
        bloc: _bloc,
        builder: (c, s) => !isLogin
            ? CheckLogin(
                loginCallBack: () {
                  _bloc.onClickLogin(context);
                },
              )
            : /*const FeatureUnderWidget()*/
        BlocBuilder<TabClimbCubit, TabClimbState>(
                bloc: _bloc,
                builder: (BuildContext context, state) {
                  return state.isBluetooth
                      ? Container(child: trueBluetooth())
                      : notBluetooth();
                }),
      ),
    );
  }

  Widget notBluetooth() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.svg.bluetooth,
            color: colorWhite,
            height: 33.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          AppText(
            LocaleKeys.bluetooth,
            style: typoLargeTextBold.copyWith(
                color: colorWhite,
                fontSize: 29.sp,
                fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 10.h, bottom: 30.h, left: 20.w, right: 20.w),
            child: AppText(
              LocaleKeys.pleaseTurnOnBl,
              style: typoExtraSmallTextRegular.copyWith(
                  color: colorWhite, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ),
          MaterialButton(
            color: Colors.deepOrange,
            height: 33.h,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            onPressed: () {
              FlutterBlueElves.instance.androidOpenBluetoothService((isOk) {
                print(isOk
                    ? "The user agrees to turn on the Bluetooth function"
                    : "The user does not agree to enable the Bluetooth function");
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.svg.bluetooth,
                  color: colorWhite,
                  height: 16.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                AppText(
                  AppLocalizations.of(context)!.turnOnBluetooth,
                  style: typoExtraSmallTextRegular.copyWith(
                      color: colorWhite, fontSize: 11.sp),
                ),
                SizedBox(
                  width: 5.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget trueBluetooth() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            SvgPicture.asset(
              Assets.svg.notlocation,
              height: 33.sp,
              color: colorWhite,
            ),
            SizedBox(
              height: 20.h,
            ),
            AppText(
              LocaleKeys.getCloser,
              style: googleFont.copyWith(
                  fontSize: 28.sp,
                  color: colorWhite,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5.h,
            ),
            AppText(
              LocaleKeys.connectToTheReClimb,
              style: googleFont.copyWith(color: colorText50, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
            BlocBuilder<TabClimbCubit, TabClimbState>(
              bloc: _bloc,
              builder: (c, s) => s.isGps
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30.h, left: 5.w),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: AppText(
                              LocaleKeys.theNearest,
                              style: googleFont.copyWith(
                                  color: colorGrey60, fontSize: 8.sp),
                            ),
                          ),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return itemNearestPlace(fakeData()[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: 10.h,
                          ),
                          itemCount: fakeData().length,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(9),
                          child: MaterialButton(
                            height: 33.h,
                            color: colorBlack,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            onPressed: () {},
                            child: Center(
                              child: AppText(
                                LocaleKeys.seeAll,
                                style: googleFont.copyWith(
                                    color: colorRed70, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            Assets.svg.notlocation,
                            height: 33.sp,
                            color: colorWhite,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          AppText(
                            LocaleKeys.turnOnLocation,
                            style: googleFont.copyWith(
                                color: colorWhite,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          AppText(
                            LocaleKeys.cantFind,
                            textAlign: TextAlign.center,
                            style: googleFont.copyWith(color: colorText50),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GradientButton(
                            height: 35.h,
                            width: 160.w,
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_location_alt,
                                  color: colorText20,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                AppText(
                                  LocaleKeys.turnOnLocation,
                                  style:
                                      googleFont.copyWith(color: colorText20),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                gradient:
                                    Utils.backgroundGradientOrangeButton(),
                                borderRadius: BorderRadius.circular(20)),
                            onTap: () {
                              Location().requestService();
                            },
                            borderRadius: BorderRadius.circular(20),
                          )
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemNearestPlace(PlacesModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: Container(
        height: 69.h,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Row(
            children: [
              Container(
                height: 55.h,
                width: 55.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.yellow),
              ),
              SizedBox(
                width: 20.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.namePlace,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Row(
                    children: [
                      Text(
                        model.nameCity,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 17),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(
                        Icons.brightness_1_rounded,
                        color: Colors.white54,
                        size: 8,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        model.distance.toString(),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 17),
                      ),
                      const AppText(
                        'km',
                        style: TextStyle(color: Colors.white54, fontSize: 17),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
