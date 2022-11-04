import 'dart:async';

import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/zoomer.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_cubit.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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

  const ZoomRoutesPage(
      {Key? key,
      required this.row,
      required this.lRoutes,
      required this.column,
      required this.sizeHoldSet})
      : super(key: key);

  @override
  State<ZoomRoutesPage> createState() => _ZoomRoutesPageState();
}

class _ZoomRoutesPageState extends State<ZoomRoutesPage> {
  late CreateRoutesCubit _bloc;
  final ZoomerController _zoomController = ZoomerController(initialScale: 6.0);
  final ZoomerController _zoomMeasureController =
      ZoomerController(initialScale: 6.0);
  final lBox = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
  final sizeHoldSet = 8.6.h;
  final row = 47;
  final column = 12;
  final List<String> lHoldSet = [
    Assets.svg.holdset1,
    Assets.svg.holdset2,
    Assets.svg.holdset3,
    Assets.svg.holdset4,
    Assets.svg.holdset5,
    Assets.svg.holdset6,
  ];
  StreamSubscription<HoldSetEvent>? _holdSetStream;
  late ScrollController _lBoxController;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((c) {
      logE("TAG JUMB:");
      _zoomMeasureController.setOffset = Offset(-2, 10);
    });

    _zoomController.onZoomUpdate(() {
      _zoomMeasureController.setScale = _zoomController.scale;
      _zoomMeasureController.setOffset = Offset(2, _zoomController.offset.dy);
    });
    _bloc = CreateRoutesCubit();
    _bloc.setData(row: row, column: column, sizeHoldSet: sizeHoldSet);
    _holdSetStream = Utils.eventBus
        .on<HoldSetEvent>()
        .listen((event) => _bloc.setHoldSet(event.holdSet));
    _lBoxController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _holdSetStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: HexColor('212121'),
      appbar: appbar(context),
      body: BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
        builder: (c, state) => state.status == StatusType.initial
            ? const Center(child: AppCircleLoading())
            : Column(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height,
                          width: 20.w,
                          alignment: Alignment.center,
                          color: colorBlack,
                          child: zoomWidget(
                              offset: Offset(2, 0.0),
                              isScaleByDx: false,
                              context,
                              _zoomMeasureController,
                              Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                width: 20.w,
                                child: MeasureWidget(
                                    scale: 1,
                                    sizeHoldSet: sizeHoldSet,
                                    row: row),
                              ))),
                      Expanded(
                          child: zoomWidget(
                              context,
                              _zoomController,
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: state.column * state.sizeHoldSet,
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
    );
  }

  Widget measureWidget(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height,
        width: 20.w,
        alignment: Alignment.center,
        color: colorBlack,
        child: zoomWidget(
          isScaleByDx: false,
          context,
          _zoomMeasureController,
          Container(
              alignment: Alignment.center,
              child:
                  MeasureWidget(scale: 1, sizeHoldSet: sizeHoldSet, row: row)),
        ),
      );

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
                  color: Colors.cyan,
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
      BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
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
                            color: state.selectIndex == index
                                ? colorOrange100
                                : colorGrey60,
                            width: state.selectIndex == index ? 1 : 0.5)),
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
          {bool isScaleByDx = true, Offset? offset}) =>
      Zoomer(
          offset: offset,
          enableTranslation: true,
          controller: controller,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          enableRotation: false,
          background: const BoxDecoration(),
          clipRotation: true,
          maxScale: 6,
          minScale: 6,
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

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, action: [
        BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
            builder: (c, state) => state.selectIndex != null &&
                    state.lRoutes[state.selectIndex!].holdSet.isNotEmpty
                ? svgButton(context, Assets.svg.turnLeft,
                    () => _bloc.turnLeftOnClick(context))
                : const SizedBox(),
            bloc: _bloc),
        const SizedBox(width: 10),
        BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
            builder: (c, state) => state.selectIndex != null &&
                    state.lRoutes[state.selectIndex!].holdSet.isNotEmpty
                ? svgButton(
                    context, Assets.svg.delete, () => _bloc.deleteOnclick())
                : const SizedBox(),
            bloc: _bloc),
        const SizedBox(width: 10),
        BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
            builder: (c, state) => state.selectIndex != null &&
                    state.lRoutes[state.selectIndex!].holdSet.isNotEmpty
                ? svgButton(context, Assets.svg.turnRight,
                    () => _bloc.turnRightOnClick(context))
                : const SizedBox(),
            bloc: _bloc),
        const SizedBox(width: 10),
        svgButton(context, Assets.svg.threeD, () {}, isBackgroundCircle: false),
        svgButton(context, Assets.svg.fullScreen, () {},
            isBackgroundCircle: false),
        svgButton(context, Assets.svg.more, () {}, isBackgroundCircle: false),
        SizedBox(width: contentPadding)
      ]);
}
