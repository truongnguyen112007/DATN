import 'dart:math';

import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_cubit.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/appbar_widget.dart';

enum RoutesAction { INFO, SHARE, COPY, ADD_FAVOURITE, ADD_TO_PLAY_LIST }

class RoutesDetailPage extends StatefulWidget {
  final int index;
  final RoutesModel model;

  const RoutesDetailPage({Key? key, required this.index, required this.model})
      : super(key: key);

  @override
  State<RoutesDetailPage> createState() => _RoutesDetailPageState();
}

class _RoutesDetailPageState extends BasePopState<RoutesDetailPage> {
  late RoutesDetailCubit _bloc;
  final lBox = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
  final sizeHoldSet = 8.6.h;
  final row = 47;
  final column = 12;
  final List<String> _lRoutes = [];
  final List<String> lHoldSet = [
    Assets.svg.holdset1,
    Assets.svg.holdset2,
    Assets.svg.holdset3,
    Assets.svg.holdset4,
    Assets.svg.holdset5,
    Assets.svg.holdset6,
  ];
  final lHeight = [0, 2, 4, 6, 8, 10, 12];

  @override
  void initState() {
    _bloc = RoutesDetailCubit();
    fakeData();
    super.initState();
  }

  void fakeData() {
    var random = Random();
    for (int i = 0; i < row * column; i++) {
      if (i % 19 == 0 || i % 15 == 0) {
        _lRoutes.add(lHoldSet[random.nextInt(lHoldSet.length)]);
      } else {
        _lRoutes.add('');
      }
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return AppScaffold(
        appbar: appbarWidget(context),
        backgroundColor: HexColor('212121'),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              blurBackground(context),
              BlocBuilder<RoutesDetailCubit, RoutesDetailState>(
                builder: (c, state) => state.status == RoutesStatus.initial
                    ? const Center(child: AppCircleLoading())
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          infoRoutesWidget(context),
                          const Spacer(),
                          Container(
                              width: sizeHoldSet * column * 1.8,
                              height: 18.h,
                              color: HexColor('898989')),
                          SizedBox(
                              width: sizeHoldSet * column * 1.66,
                              child: Image.asset(Assets.png.tesst.path)),
                          Flexible(
                              flex: 15,
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
                                        lineGreyGradient(context, false),
                                        Container(
                                          decoration: BoxDecoration(
                                              gradient: gradientBackground()),
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width:
                                                    column * sizeHoldSet + 16.w,
                                                height: 2,
                                                color: HexColor('A3A3A3'),
                                              ),
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
                                                        boxNameWidget(context),
                                                        routesWidget(context),
                                                        boxNameWidget(context),
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
                                        lineGreyGradient(context, true),
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
                                                5.5),
                                        child: SvgPicture.asset(Assets.svg.man,
                                            height:
                                                row * sizeHoldSet / 6 + 2.h),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: infoHeightWidget(context),
                                  ))
                                ],
                              )),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 7.h,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: HexColor('6B6B6B').withOpacity(0.05),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                )
                              ]),
                            ),
                          ),
                          actionWidget()
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
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: colorWhite, blurRadius: 100)]),
        ),
      ));

  PreferredSizeWidget appbarWidget(BuildContext context) => appBarWidget(
      context: context,
      action: [
        Icon(Icons.more_vert, color: colorWhite.withOpacity(0.6)),
        SizedBox(width: contentPadding)
      ],
      titleStr: widget.model.name);

  Widget boxNameWidget(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < lBox.length; i++)
            AppText(lBox[i],
                style: typoW400.copyWith(fontSize: 4.sp, height: 1))
        ],
      );

  Widget heightWidget(bool isLeft) => Container(
      height: row * sizeHoldSet,
      alignment: Alignment.center,
      decoration: BoxDecoration(gradient: gradientBackground()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = row; i >= 0; i--)
            Padding(
                padding: EdgeInsets.only(
                    left: isLeft ? 3 : 0, right: isLeft ? 0 : 3),
                child: Text('$i', style: typoW400.copyWith(fontSize: 4.sp)))
        ],
      ));

  Widget lineGreyGradient(BuildContext context, bool isLeft) => Stack(
        children: [
          Container(
            width: 22.w,
            decoration: BoxDecoration(gradient: gradientBackground()),
          ),
          Positioned.fill(
              child: Align(
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(width: 5.w, color: HexColor('FF5A00')),
          )),
        ],
      );

  Widget infoRoutesWidget(BuildContext context) => Container(
        color: colorBlack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            itemInfoWidget(context, AppLocalizations.of(context)!.author,
                widget.model.grade, widget.model.status ?? '',
                padding: EdgeInsets.only(left: contentPadding, bottom: 3)),
            itemInfoWidget(context, AppLocalizations.of(context)!.user,
                widget.model.grade, '',
                padding: const EdgeInsets.only(bottom: 3)),
            itemInfoWidget(context, AppLocalizations.of(context)!.popularity,
                '100k', widget.model.author,
                padding: EdgeInsets.only(right: contentPadding, bottom: 3))
          ],
        ),
      );

  Widget itemInfoWidget(
          BuildContext context, String title, String grade, String status,
          {EdgeInsetsGeometry? padding}) =>
      Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(title,
                style: typoW600.copyWith(
                    fontSize: 9.sp, color: colorText0.withOpacity(0.87))),
            AppText(grade, style: typoW700.copyWith(fontSize: 22.5.sp)),
            AppText(
              status,
              style: typoW400.copyWith(
                  fontSize: 12.5.sp, color: colorText0.withOpacity(0.87)),
            )
          ],
        ),
      );

  Widget routesWidget(BuildContext context) => SizedBox(
        width: column * sizeHoldSet,
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: _lRoutes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: column, childAspectRatio: 1.0),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => _tapped(index),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: HexColor('8A8A8A'), width: 0.5)),
                  child: Center(
                      child: _lRoutes[index].isNotEmpty
                          ? ShaderMask(
                              child: SvgPicture.asset(
                                _lRoutes[index],
                                width: 10,
                              ),
                              shaderCallback: (Rect bounds) =>
                                  Utils.backgroundGradientOrangeButton()
                                      .createShader(
                                          const Rect.fromLTRB(0, 0, 10, 10)),
                            )
                          : const SizedBox()),
                ),
              );
            }),
      );

  Widget infoHeightWidget(BuildContext context) => SizedBox(
        height: row * sizeHoldSet,
        width: MediaQuery.of(context).size.width / 3.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = lHeight.length - 1; i >= 0; i--)
              i == 0
                  ? const SizedBox()
                  : AppText('${lHeight[i]}m -------',
                      style: typoW400.copyWith(
                          fontSize: 14.sp, color: colorText0.withOpacity(0.6)))
          ],
        ),
      );

  void _tapped(int index) {}

  Widget actionWidget() => Container(
        height: 45.h,
        color: colorBlack,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: itemActionWidget(AppLocalizations.of(context)!.info,
                    Assets.svg.info, RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(AppLocalizations.of(context)!.share,
                    Assets.svg.share, RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(AppLocalizations.of(context)!.copy,
                    Assets.svg.copy, RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(
                    AppLocalizations.of(context)!.add_favourite,
                    Assets.svg.like,
                    RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(
                    AppLocalizations.of(context)!.addToPlaylist,
                    Assets.svg.addToPlayList,
                    RoutesAction.INFO))
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
        onTap: () => _bloc.handleAction(action),
      );

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
}
