import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/modules/login_to_wall/login_to_wall_cubit.dart';
import 'package:base_bloc/modules/login_to_wall/login_to_wall_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/hex_color.dart';
import '../../components/app_text.dart';
import '../../data/model/playlist_wall_login_model.dart';
import '../../data/model/wall_model.dart';
import '../../localization/locale_keys.dart';
import '../../utils/app_utils.dart';

class LoginToWall extends StatefulWidget {
  final int routePage;
  final WallModel model;
  final String currentIndex;

  const LoginToWall({
    Key? key,
    required this.model, required this.routePage, required this.currentIndex
  }) : super(key: key);

  @override
  State<LoginToWall> createState() => _LoginToWallState();
}

class _LoginToWallState extends BasePopState<LoginToWall> {
  late LoginToWallCubit _bloc;

  @override
  void initState() {
    _bloc = LoginToWallCubit();
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        backgroundColor: colorGreyBackground,
        appbar: AppBar(
          backgroundColor: colorBlack,
          title: AppText("Climb",style: googleFont.copyWith(color: colorWhite),),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemWallLogIn(widget.model,stt:widget.currentIndex),
            Container(
              height: 36.h,
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: colorGreyBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colorPrimary)),
              child: Center(
                child: AppText(
                  "Log out",
                  style: googleFont.copyWith(color: colorPrimary),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 16, bottom: 10.h),
              child: AppText(
                "Playlist",
                style: googleFont.copyWith(color: colorWhite),
              ),
            ),
            Expanded(
              child: BlocBuilder<LoginToWallCubit, LoginToWallState>(
                bloc: _bloc,
                builder: (c, s) => ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return itemPlaylist(fakeDataAuthor()[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: 10.h,
                  ),
                  itemCount: fakeDataAuthor().length,
                ),
              ),
            )
          ],
        ));
  }

  itemPlaylist(PlaylistWallLoginModel model) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: model.icon != null ? 8.w : 10.w, right: model.icon !=null ? 8.w:10.w),
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              gradient:model.rank == "7B" ?  LinearGradient(colors: [
                HexColor('D11D00'),
                HexColor('D17800').withOpacity(0.743),
                HexColor('D17800').withOpacity(1)
              ]) :  LinearGradient(colors: [
                HexColor("A77208"),
                HexColor("005926").withOpacity(0.4),
                HexColor("005926").withOpacity(1)
              ]),
                border: Border.all(color: model.icon != null ? colorMainText : colorTransparent) ,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: 10.w,right: 10.w),
                        child: Icon(model.icon,color: colorWhite,size: 6,),
                      ),
                      AppText(
                        model.rank,
                        style: googleFont.copyWith(
                            color: colorWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 30.sp),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppText(
                              model.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 21),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: AppText(
                                  maxLine: 1,
                                  overflow: TextOverflow.ellipsis,
                                  model.date,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 21)))
                        ],
                      ),
                      Row(
                        children: [
                          AppText(
                            "${model.height}m",
                            style: TextStyle(
                                color: Colors.white54, fontSize: 14.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          const Icon(
                            Icons.brightness_1_rounded,
                            color: Colors.white54,
                            size: 7,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          AppText(
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                            model.author,
                            style: TextStyle(
                                color: Colors.white54, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: colorBlue40,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ))
              ],
            ),
          ),
        ),
        Visibility(
          visible: model.icon == null,
          child: Container(
              margin: EdgeInsets.only(left: model.icon != null ? 8.w : 10.w, right: model.icon !=null ? 8.w:10.w),
              height: 70.h,
              decoration: BoxDecoration(
                  color: colorBlack.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20))),
        )
      ],
    );
  }

  Widget itemWallLogIn(WallModel model, {String? stt}) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w,top: 10.h,bottom: 10.h),
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: AppText(
                    stt??'',
                    style: googleFont.copyWith(
                        color: colorWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 30.sp),
                  ),
                )),
            Expanded(
              flex: model.reservation != null ? 4 : 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: AppText(
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      (model.name ?? '') + model.deviceId,
                      style: const TextStyle(color: Colors.white, fontSize: 21),
                    ),
                  ),
                  Row(
                    children: [
                      AppText(
                        "${model.numberPlayer} ${LocaleKeys.climbers.tr()}",
                        style:
                        TextStyle(color: Colors.white54, fontSize: 14.sp),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(
                        Icons.brightness_1_rounded,
                        color: Colors.white54,
                        size: 7,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        model.rank??'A',
                        style:
                        TextStyle(color: Colors.white54, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: model.reservation != null,
              child: Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 5.w),
                  decoration: BoxDecoration(
                    gradient: Utils.backgroundGradientOrangeButton(),
                    color: colorPrimary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Reservation",
                        style: googleFont.copyWith(
                            color: colorWhite, fontSize: 15.sp),
                      ),
                      AppText(
                        model.reservation ?? "",
                        style: googleFont.copyWith(
                            color: colorWhite, fontSize: 15.sp),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  int get tabIndex => widget.routePage;
}
