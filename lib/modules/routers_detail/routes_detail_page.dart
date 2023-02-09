import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_network_image.dart';
import 'package:base_bloc/components/app_not_data_widget.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/holds_param.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_cubit.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/appbar_widget.dart';
import '../../localization/locale_keys.dart';

enum RoutesAction {
  INFO,
  SHARE,
  COPY,
  ADD_FAVOURITE,
  ADD_TO_PLAY_LIST,
  EDIT,
  PUBLISH,
  REMOVE_FROM_PLAYLIST,
  REOMVE_FROM_FAV
}

class RoutesDetailPage extends StatefulWidget {
  final int index;
  final RoutesModel model;
  final VoidCallback? publishCallback;
  final bool isSaveDraft; // true when create route and save draft

  const RoutesDetailPage(
      {Key? key,
      required this.index,
      required this.model,
      this.publishCallback,
      this.isSaveDraft = false})
      : super(key: key);

  @override
  State<RoutesDetailPage> createState() => _RoutesDetailPageState();
}

class _RoutesDetailPageState extends BasePopState<RoutesDetailPage> {
  late RoutesDetailCubit _bloc;
  var sizeHoldSet = 8.6.h;
  var row = 47;
  var column = 12;
  var lHeight = [2, 4, 6, 8, 10, 12];

  @override
  void initState() {
    getHeightOfRoute();
    _bloc = RoutesDetailCubit(widget.model, widget.isSaveDraft,row,column);
    super.initState();
  }

  void getHeightOfRoute() {
    if (widget.model.height != null) {
      row = widget.model.height! * 5;
      switch (widget.model.height) {
        case 12:
          lHeight = [2, 4, 6, 8, 10, 12];
          sizeHoldSet = 7.2.h;
          return;
        case 9:
          lHeight = [2, 4, 6, 8, 9];
          return;
        case 6:
          lHeight = [2, 4, 6];
          return;
        case 3:
          lHeight = [2, 3];
          return;
        default:
          sizeHoldSet = 8.6.h;
      }
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        appbar: appbarWidget(context),
        backgroundColor: colorBackgroundColor,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              blurBackground(context),
              BlocBuilder<RoutesDetailCubit, RoutesDetailState>(
                builder: (c, state) => state.status == RoutesStatus.initial
                    ? const Center(child: AppCircleLoading())
                    : state.status == RoutesStatus.failure
                        ? const Center(child: AppNotDataWidget())
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              infoRoutesWidget(context,state),
                              Container(
                                  width: sizeHoldSet * column * 1.8,
                                  height: 18.h,
                                  color: HexColor('898989')),
                              SizedBox(
                                  width: sizeHoldSet * column * 1.66,
                                  child: Image.asset(Assets.png.tesst.path)),
                              Expanded(
                                  child: Stack(
                                children: [
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        wallWidget(context, false),
                                        Container(
                                          decoration: BoxDecoration(
                                              gradient: gradientBackground()),
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  width: column * sizeHoldSet +
                                                      16.w,
                                                  height: 2,
                                                  color: HexColor('A3A3A3')),
                                              Container(
                                                  width: column * sizeHoldSet +
                                                      16.w,
                                                  height: 5,
                                                  color: colorBlack),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  heightWidget(true),
                                                  Container(
                                                    width: column * sizeHoldSet,
                                                    decoration: BoxDecoration(
                                                        gradient:
                                                            gradientBackground()),
                                                    child: Column(
                                                      children: [
                                                        infoNameWidget(context),
                                                        routesWidget(context,state),
                                                        infoNameWidget(context),
                                                      ],
                                                    ),
                                                  ),
                                                  heightWidget(false),
                                                ],
                                              ),
                                              SizedBox(
                                                height: sizeHoldSet * 1.5,
                                              )
                                            ],
                                          ),
                                        ),
                                        wallWidget(context, true),
                                      ],
                                    ),
                                  )),
                                  Positioned(
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5),
                                              child: SvgPicture.asset(
                                                  Assets.svg.man,
                                                  height: 65.h)))),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: measureHeightWidget(context),
                                  ))
                                ],
                              )),
                              Container(
                                height: 4.h,
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color:
                                          HexColor('6B6B6B').withOpacity(0.05),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 0))
                                ]),
                              ),
                              actionWidget(state)
                            ],
                          ),
                bloc: _bloc,
              ),
            ],
          ),
        ));
  }

  Widget blurBackground(BuildContext context) => Positioned.fill(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
              height: 40,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(color: colorWhite, blurRadius: 100)
              ]))));

  PreferredSizeWidget appbarWidget(BuildContext context) => appBarWidget(
        context: context,
        action: [
          userId == widget.model.userId
              ? InkWell(
                  child:
                      Icon(Icons.more_vert, color: colorWhite.withOpacity(0.6)),
                  onTap: () => _bloc.editRouteOnclick(context, widget.model),
                )
              : const SizedBox(),
          SizedBox(width: contentPadding)
        ],
        titleStr:
            "${widget.model.name!}",
      );

  Widget infoNameWidget(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        for (int i = 0; i < lHoldSetName.length; i++)
          AppText(lHoldSetName[i],
              style: typoW400.copyWith(fontSize: 4.sp, height: 1))
      ]);

  Widget heightWidget(bool isLeft) => Container(
      width: 8.w,
      height: row * sizeHoldSet,
      alignment: Alignment.center,
      decoration: BoxDecoration(gradient: gradientBackground()),
      child: ListView.builder(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: row,
          itemBuilder: (BuildContext context, int index) => Container(
              alignment: !isLeft ? Alignment.centerLeft : Alignment.centerRight,
              height: sizeHoldSet,
              child: AppText(' ${index + 1}',
                  style: typoW400.copyWith(fontSize: 4.sp)))));

  Widget wallWidget(BuildContext context, bool isLeft) => Stack(
        children: [
        Container(
            width: widget.model.height == 12 ? 18.5.w : 22.w,
            decoration: BoxDecoration(gradient: gradientBackground())),
        Positioned.fill(
              child: Align(
                  alignment:
                    isLeft ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(width: 5.w, color: HexColor('FF5A00'))))
      ]);

  Widget infoRoutesWidget(BuildContext context,RoutesDetailState state) => Container(
        color: colorBlack,
    child: (state.model.published ?? true) ? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: itemInfoWidget(
                    context,
                    LocaleKeys.author.tr(),
                        Utils.getGrade(state.model.authorGrade ?? 0),
                        (state.model.hasConner ?? false)
                            ? LocaleKeys.corner.tr()
                            : '',
                        padding:
                            EdgeInsets.only(left: contentPadding, bottom: 2))),
                Expanded(
                    child: itemInfoWidget(
                    context,
                    LocaleKeys.user.tr(),
                        state.model.userGrade.toString(),
                    '',
                    padding: const EdgeInsets.only(bottom: 2))),
            Expanded(
                child: itemInfoWidget(
                    context,
                    LocaleKeys.popularity.tr(),
                    '${state.model.popurlarity}k',
                    '',
                    padding: EdgeInsets.only(right: contentPadding, bottom: 2)))
          ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: contentPadding),
                itemInfoWidget(
                    context,
                    LocaleKeys.author.tr(),
                    Utils.getGrade(state.model.authorGrade ?? 0),
                    (state.model.hasConner ?? false) ? LocaleKeys.corner.tr() : '',
                    padding: EdgeInsets.only(left: contentPadding,bottom: 2)),
                  SizedBox(width: contentPadding * 2),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorWhite),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      margin: EdgeInsets.only(
                          bottom: (state.model.hasConner ?? false) ? 0 : 12),
                      child: AppText(LocaleKeys.draft.tr(),
                          style: typoW400.copyWith(
                              fontSize: 11.sp, color: colorText90)))
                ]));

  Widget itemInfoWidget(
          BuildContext context, String title, String grade, String status,
          {EdgeInsetsGeometry? padding}) =>
      Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(title.toUpperCase(),
                style: typoW600.copyWith(
                    fontSize: 9.sp, color: colorText0.withOpacity(0.87)),
                maxLine: 1,
                overflow: TextOverflow.ellipsis),
            AppText(grade,
                style: typoW700.copyWith(fontSize: 22.5.sp),
                maxLine: 1,
                overflow: TextOverflow.ellipsis),
            AppText(status,
                style: typoW400.copyWith(
                    fontSize: 12.5.sp, color: colorText0.withOpacity(0.87)),
                maxLine: 1,
                overflow: TextOverflow.ellipsis)
          ],
        ),
      );

  Widget routesWidget(BuildContext context,RoutesDetailState state) => SizedBox(
        width: column * sizeHoldSet,
      child: GridView.builder(
          reverse: true,
          shrinkWrap: true,
              itemCount: state.lHoldSet.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: column, childAspectRatio: 1.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: HexColor('8A8A8A'), width: 0.5)),
                child: Center(
                    child: state.lHoldSet[index] is HoldParam
                        ? SizedBox(
                            width: 8,
                            child: RotatedBox(
                                quarterTurns: state.lHoldSet[index].rotate,
                                child: AppNetworkImage(
                                    errorSource:
                                        '${ConstantKey.BASE_URL}hold/1/image',
                                    source: state.lHoldSet[index].imageUrl)))
                        : const SizedBox()));
          }));

  Widget measureHeightWidget(BuildContext context) => Container(
      margin: EdgeInsets.only(bottom: sizeHoldSet * 1.9),
      alignment: Alignment.bottomLeft,
      height: row * sizeHoldSet,
      width: MediaQuery.of(context).size.width / 3.9,
      child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemBuilder: (s, i) => Container(
              alignment: Alignment.topRight,
              height: i == 0
                  ? sizeHoldSet * 10
                  : i == (lHeight.length - 1)
                      ? (lHeight[i] - lHeight[i - 1] == 1
                          ? sizeHoldSet * 5
                          : sizeHoldSet * 10)
                      : (lHeight[i] - lHeight[i - 1] == 1
                          ? sizeHoldSet * 5
                          : sizeHoldSet * 10),
              child: AppText('${lHeight[i]}m -------',
                  style: typoW400.copyWith(
                      height: 1,
                      fontSize: 14.sp,
                      color: colorText0.withOpacity(0.6)))),
          itemCount: lHeight.length));

  void _tapped(int index) {}

  Widget actionWidget(RoutesDetailState state) => Container(
        height: 45.h,
        color: colorBlack,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: itemActionWidget(
                    LocaleKeys.info.tr(), Assets.svg.info, RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(
                    LocaleKeys.share.tr(), Assets.svg.share, RoutesAction.SHARE)),
            (state.model.published ?? true)
                ? Expanded(
                    child: itemActionWidget(LocaleKeys.copy.tr(),
                        Assets.svg.copy, RoutesAction.COPY))
                : Expanded(
                    child: itemActionWidget(LocaleKeys.edit.tr(),
                        Assets.svg.edit, RoutesAction.EDIT)),
            (state.model.published ?? true)
                ? Expanded(
                    child: !(state.model.favouriteIn ?? false)
                        ? itemActionWidget(LocaleKeys.add_favourite.tr(),
                            Assets.svg.like, RoutesAction.ADD_FAVOURITE)
                        : itemActionWidget(LocaleKeys.removeFromFavorite.tr(),
                            Assets.svg.liked, RoutesAction.REOMVE_FROM_FAV))
                : Expanded(
                    child: itemActionWidget(LocaleKeys.publish.tr(),
                        Assets.svg.fly, RoutesAction.PUBLISH)),
            Expanded(
                child: !(state.model.playlistIn ?? false)
                    ? itemActionWidget(LocaleKeys.addToPlaylist.tr(),
                        Assets.svg.addToPlayList, RoutesAction.ADD_TO_PLAY_LIST)
                    : itemActionWidget(LocaleKeys.removeFromPlaylist.tr(),
                        Assets.svg.removepl, RoutesAction.REMOVE_FROM_PLAYLIST))
          ],
        ),
      );

  Widget itemActionWidget(String title, String icon, RoutesAction action) =>
      InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 1, right: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(icon),
                ),
                const SizedBox(height: 3),
                AppText(
                  title,
                  style: typoW400.copyWith(
                      fontSize: 12, color: colorText0.withOpacity(0.6)),
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          onTap: () =>
              _bloc.handleAction(action, context, widget.publishCallback));

  LinearGradient gradientBackground() => LinearGradient(colors: [
        HexColor('747474'),
        HexColor('6B6B6B'),
        HexColor('494949'),
        HexColor('494949'),
        HexColor('494949'),
        HexColor('494949'),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  @override
  int get tabIndex => widget.index;

  @override
  bool get isNewPage => true;

  @override
  int get timeDelayToShowBottomNavigation => 400;
}
