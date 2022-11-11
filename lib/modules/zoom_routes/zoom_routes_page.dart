import 'dart:async';

import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/measure_name_widget.dart';
import 'package:base_bloc/components/zoomer.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_cubit.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

import '../../base/hex_color.dart';
import '../../components/app_button.dart';
import '../../components/app_circle_loading.dart';
import '../../components/app_text.dart';
import '../../components/appbar_widget.dart';
import '../../components/measure_widget.dart';
import '../../data/eventbus/hold_set_event.dart';
import '../../data/globals.dart';
import '../../data/model/hold_set_model.dart';
import '../../gen/assets.gen.dart';
import '../../localizations/app_localazations.dart';
import '../../router/router_utils.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../create_routes/create_routes_cubit.dart';
import '../create_routes/create_routes_state.dart';
import '../persons_page/persons_page_state.dart';

class ZoomRoutesPage extends StatefulWidget {
  final int row;
  final int column;
  final double sizeHoldSet;
  final List<HoldSetModel> lRoutes;
  final int currentIndex;

  const ZoomRoutesPage(
      {Key? key,
      required this.currentIndex,
      required this.row,
      required this.lRoutes,
      required this.column,
      required this.sizeHoldSet})
      : super(key: key);

  @override
  State<ZoomRoutesPage> createState() => _ZoomRoutesPageState();
}

class _ZoomRoutesPageState extends State<ZoomRoutesPage> {
  late ZoomRoutesCubit _bloc;
  final ZoomerController _zoomController = ZoomerController(initialScale: 4.0);
  final ZoomerController _zoomMeasureNameController =
      ZoomerController(initialScale: 4.0);
  final ZoomerController _zoomMeasureController =
      ZoomerController(initialScale: 4.0);
  final lBox = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
  final sizeHoldSet = 8.6.h;
  final row = 47;
  final column = 12;
  Offset? offset;
  StreamSubscription<HoldSetEvent>? _holdSetStream;
  late ScrollController _lBoxController;

  @override
  void initState() {
    _bloc = ZoomRoutesCubit();
    _zoomController.onZoomUpdate(() {
      _zoomMeasureController.setOffset = Offset(-7, _zoomController.offset.dy);
      _zoomMeasureNameController.setOffset =
          Offset(_zoomController.offset.dx, -9);
    });
    _bloc.setData(
        currentIndex: widget.currentIndex,
        row: row,
        column: column,
        sizeHoldSet: sizeHoldSet,
        lRoutes: widget.lRoutes);
    _holdSetStream = Utils.eventBus
        .on<HoldSetEvent>()
        .listen((event) => _bloc.setHoldSet(event.holdSet));
    _lBoxController = ScrollController();
    checkOffset();
    super.initState();
  }

  void checkOffset() {
    var dx = 0.0;
    var dy = 0.0;
    if (widget.currentIndex % 12 == 0 ||
        widget.currentIndex == 1 ||
        widget.currentIndex == 2 ||
        widget.currentIndex == 3 ||
        widget.currentIndex == 4 ||
        widget.currentIndex == 5 ||
        widget.currentIndex % 12 == 1 ||
        widget.currentIndex % 12 == 2 ||
        widget.currentIndex % 12 == 3 ||
        widget.currentIndex % 12 == 4 ||
        widget.currentIndex % 12 == 5) {
      dx = 21;
    } else if (widget.currentIndex == 12 ||
        widget.currentIndex == 11 ||
        widget.currentIndex == 10 ||
        widget.currentIndex % 12 == 11 ||
        widget.currentIndex % 12 == 10 ||
        widget.currentIndex % 12 == 9 ||
        widget.currentIndex % 12 == 8 ||
        widget.currentIndex % 12 == 7) {
      dx = -21;
    }
    if (widget.currentIndex <= 84) {
      dy = 166;
    } else if (widget.currentIndex > 84 && widget.currentIndex <= 156) {
      dy = 89;
    } else if (widget.currentIndex > 156 && widget.currentIndex < 252) {
      dy = 36;
    } else if (widget.currentIndex > 252 && widget.currentIndex < 324) {
      dy = 11;
    } else if (widget.currentIndex > 324 && widget.currentIndex < 396) {
      dy = -54;
    } else if (widget.currentIndex > 396 && widget.currentIndex < 468) {
      dy = -127;
    } else {
      dy = -166;
    }
    offset = Offset(dx, dy);
  }

  @override
  void dispose() {
    _holdSetStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: AppScaffold(
          backgroundColor: HexColor('212121'),
          appbar: appbar(context),
          body: BlocBuilder<ZoomRoutesCubit, ZoomRoutesState>(
            builder: (c, state) => state.status == StatusType.initial
                ? const Center(child: AppCircleLoading())
                : Column(
                    children: [
                      Container(
                          color: colorBlack,
                          padding: EdgeInsets.only(left: 25.w),
                          height: 20.h,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              zoomWidget(
                                  context,
                                  _zoomMeasureNameController,
                                  MeasureNameBoxWidget(
                                      lBox: lBox, sizeHoldSet: sizeHoldSet),
                                  offset: Offset(offset!.dx, -8)),
                              Container(
                                  color: Colors.transparent,
                                  height: 20.h,
                                  width: MediaQuery.of(context).size.width)
                            ],
                          )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height,
                              width: 25.w,
                              alignment: Alignment.center,
                              color: colorBlack,
                              child: Stack(
                                children: [
                                  zoomWidget(
                                      offset: Offset(-7, offset!.dy),
                                      isScaleByDx: false,
                                      context,
                                      _zoomMeasureController,
                                      Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width: 25.w,
                                          child: MeasureWidget(
                                              scale: 1,
                                              sizeHoldSet: sizeHoldSet,
                                              row: row))),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: 25.w,
                                      color: Colors.transparent)
                                ],
                              )),
                          Expanded(
                              child: zoomWidget(
                                  offset: offset,
                                  context,
                                  _zoomController,
                                  isLimitOffset: true,
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width:
                                              state.column * state.sizeHoldSet,
                                          decoration: BoxDecoration(
                                              gradient: gradientBackground()),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: routesWidget(context),
                                          ),
                                        ),
                                      ])))
                        ],
                      )),
                      optionWidget()
                    ],
                  ),
            bloc: _bloc,
          ),
        ),
        onWillPop: () async => _bloc.goBack(context));
  }

  Widget optionWidget() => Container(
        color: colorBlack,
        padding: EdgeInsets.only(
            left: contentPadding, right: contentPadding, top: 5, bottom: 5),
        child: Row(
          children: [
            AppButton(
              shapeBorder: RoundedRectangleBorder(
                  side: const BorderSide(color: colorWhite),
                  borderRadius: BorderRadius.circular(50)),
              title: LocaleKeys.cancel,
              height: 32.h,
              textStyle: typoSmallTextRegular.copyWith(color: colorText0),
              onPress: () => RouterUtils.pop(context),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.only(
                  left: contentPadding,
                  right: contentPadding,
                  top: 5,
                  bottom: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colorOrange100, colorOrange50]),
                  borderRadius: BorderRadius.circular(50)),
              height: 32.h,
              child: AppText(
                LocaleKeys.save_daft,
                style: typoSmallTextRegular.copyWith(color: colorText0),
              ),
            )
          ],
        ),
      );

  Widget routesWidget(BuildContext context) =>
      BlocBuilder<ZoomRoutesCubit, ZoomRoutesState>(
          bloc: _bloc,
          builder: (c, state) => GridView.builder(
              controller: _lBoxController,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.lRoutes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: state.column, childAspectRatio: 1.0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onLongPress: () => _bloc.itemOnLongPress(index, context),
                  onTap: () => _bloc.itemOnClick(index, context),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: state.currentIndex == index
                                ? colorOrange100
                                : colorGrey60,
                            width: state.currentIndex == index ? 1 : 0.5)),
                    child: Center(
                        child: state.lRoutes[index].holdSet.isNotEmpty
                            ? RotatedBox(
                                quarterTurns: state.lRoutes[index].rotate,
                                child: ShaderMask(
                                    child: SvgPicture.asset(
                                        state.lRoutes[index].holdSet,
                                        width: 10),
                                    shaderCallback: (Rect bounds) =>
                                        Utils.backgroundGradientOrangeButton()
                                            .createShader(const Rect.fromLTRB(
                                                0, 0, 10, 10))))
                            : const SizedBox()),
                  ),
                );
              }));

  Widget zoomWidget(
          BuildContext context, ZoomerController controller, Widget widget,
          {bool isScaleByDx = true,
          bool isLimitOffset = false,
          Offset? offset}) =>
      Zoomer(
          offset: offset,
          isLimitOffset: isLimitOffset,
          enableTranslation: true,
          controller: controller,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          enableRotation: false,
          background: const BoxDecoration(),
          clipRotation: true,
          maxScale: 4,
          minScale: 4,
          child: widget);

  LinearGradient gradientBackground() => LinearGradient(colors: [
        HexColor('747474'),
        HexColor('6B6B6B'),
        HexColor('494949'),
        HexColor('494949'),
        HexColor('494949'),
        HexColor('494949'),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  Widget svgButton(BuildContext context, String icon, VoidCallback onTab,
          {bool isBackgroundCircle = true}) =>
      Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
          child: AspectRatio(
              aspectRatio: 1 / 1,
              child: InkWell(
                  child: Container(
                      padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: isBackgroundCircle
                              ? colorWhite
                              : Colors.transparent),
                      child: SvgPicture.asset(icon,
                          color: isBackgroundCircle ? colorBlack : colorWhite)),
                  onTap: () => onTab.call())));

  Widget spaceMenu() => const SizedBox(width: 30);

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
          context: context,
          onPressed: () => _bloc.goBack(context),
          action: [
            BlocBuilder<ZoomRoutesCubit, ZoomRoutesState>(
                builder: (c, state) => state.currentIndex != null &&
                        state.lRoutes[state.currentIndex!].holdSet.isNotEmpty
                    ? svgButton(context, Assets.svg.turnLeft,
                        () => _bloc.turnLeftOnClick(context))
                    : const SizedBox(),
                bloc: _bloc),
            const SizedBox(width: 10),
            BlocBuilder<ZoomRoutesCubit, ZoomRoutesState>(
                builder: (c, state) => state.currentIndex != null &&
                        state.lRoutes[state.currentIndex!].holdSet.isNotEmpty
                    ? svgButton(
                        context, Assets.svg.delete, () => _bloc.deleteOnclick())
                    : const SizedBox(),
                bloc: _bloc),
            const SizedBox(width: 10),
            BlocBuilder<ZoomRoutesCubit, ZoomRoutesState>(
                builder: (c, state) => state.currentIndex != null &&
                        state.lRoutes[state.currentIndex!].holdSet.isNotEmpty
                    ? svgButton(context, Assets.svg.turnRight,
                        () => _bloc.turnRightOnClick(context))
                    : const SizedBox(),
                bloc: _bloc),
            const SizedBox(width: 10),
            svgButton(context, Assets.svg.threeD, () {},
                isBackgroundCircle: false),
            svgButton(context, Assets.svg.fullScreen, () {},
                isBackgroundCircle: false),
            svgButton(context, Assets.svg.more, () {},
                isBackgroundCircle: false),
            SizedBox(width: contentPadding)
          ]);
}
