import 'dart:async';

import 'package:base_bloc/components/app_network_image.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/measure_name_widget.dart';
import 'package:base_bloc/components/zoomer.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_cubit.dart';
import 'package:base_bloc/modules/zoom_routes/zoom_routes_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
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
import '../../data/globals.dart' as globals;
import '../../data/model/hold_set_model.dart';
import '../../data/model/info_route_model.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../../router/router_utils.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';
import '../persons_page/persons_page_state.dart';
import 'dart:io';
class ZoomRoutesPage extends StatefulWidget {
  final int heightOfRoute;
  final int row;
  final int column;
  final double sizeHoldSet;
  final List<HoldSetModel> lHoldSet;
  final int currentIndex;
  final double heightOffScreen;
  final bool isEdit;
  final RoutesModel? model;
  final InfoRouteModel? infoRouteModel;
  final int? holdSetIndex;
  const ZoomRoutesPage(
      {Key? key,
      this.holdSetIndex = 0,
      this.infoRouteModel,
      required this.heightOfRoute,
      required this.currentIndex,
      this.isEdit = false,
      this.model,
      required this.row,
      required this.lHoldSet,
      required this.column,
      required this.sizeHoldSet,
      required this.heightOffScreen})
      : super(key: key);

  @override
  State<ZoomRoutesPage> createState() => _ZoomRoutesPageState();
}

class _ZoomRoutesPageState extends State<ZoomRoutesPage> {
  late ZoomRoutesCubit _bloc;
  late ZoomerController _zoomController;
  late ZoomerController _zoomMeasureNameController;
  late ZoomerController _zoomMeasureController;
  late MeasureNameBoxController _measureNameBoxController;
  late MeasureHeightController _measureHeightController;
  var _scale =4.0;
  late double sizeHoldSet;
  late int row;
  late int column;
  Offset? offset;
  StreamSubscription<HoldSetEvent>? _holdSetStream;
  late ScrollController _lBoxController;
  var dxMeasureHeight =Platform.isAndroid ?-10.5 : -11.0;
  var dyMeasureBoxName =Platform.isAndroid ?-9.0: -10.0;

  @override
  void initState() {
    _bloc = ZoomRoutesCubit();
    _zoomController = ZoomerController(initialScale: 4.0);
    _zoomMeasureNameController = ZoomerController(initialScale: 4.0);
    _zoomMeasureController = ZoomerController(initialScale: 4.0);
    _measureNameBoxController = MeasureNameBoxController();
    _measureHeightController = MeasureHeightController();
    sizeHoldSet = widget.sizeHoldSet;
    row = widget.row;
    column = widget.column;
    _zoomController.onZoomUpdate(() {
      _zoomMeasureController.setOffset =
          Offset(dxMeasureHeight, _zoomController.offset.dy);
      _zoomMeasureNameController.setOffset =
          Offset(_zoomController.offset.dx, dyMeasureBoxName);
    });
    _bloc.setData(
        holdSetIndex: widget.holdSetIndex ?? 0,
        model: widget.model,
        isEdit: widget.isEdit,
        currentIndex: widget.currentIndex,
        row: row,
        column: column,
        sizeHoldSet: sizeHoldSet,
        lHoldSet: widget.lHoldSet);
    _holdSetStream = Utils.eventBus
        .on<HoldSetEvent>()
        .listen((event) => _bloc.setHoldSet(event.holdSet,event.holdSetIndex));
    _lBoxController = ScrollController();
    offset = _bloc.getOffset(widget.currentIndex, widget.heightOffScreen,widget.heightOfRoute);
    super.initState();
  }

  void setScale(double scale) {
    _scale = scale;
    _zoomController.setScale = scale;
    _zoomController.setOffset = const Offset(0.0, 0.0);
    _zoomMeasureNameController.setOffset =  Offset(0,Platform.isAndroid ? -9: -10);
    _measureNameBoxController.setScale = scale;
    _measureHeightController.setScale = scale;
    _zoomMeasureController.setScale = scale;
      _zoomMeasureNameController.setScale = scale;
    dxMeasureHeight =
        scale == 1.0 ? -10 : (scale == 2 ? -8 : (scale == 3 ? -9 : -10.5));
    _zoomMeasureController.setOffset = Offset(dxMeasureHeight, 0);
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
            builder: (c, state) {
              if (state.scale != _scale) setScale(state.scale);
              return state.status == StatusType.initial
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
                                measureNameWidget(context, state),
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
                            measureHeightWidget(context, state),
                            Expanded(child: infoRouteWidget(context, state))
                          ],
                        )),
                        optionWidget()
                      ],
                    );
            },
            bloc: _bloc,
          ),
        ),
        onWillPop: () async => _bloc.goBack(context));
  }

  Widget measureNameWidget(BuildContext context, ZoomRoutesState state) =>
      zoomWidget(
          scale: state.scale,
          context,
          _zoomMeasureNameController,
          MeasureNameBoxWidget(
              controller: _measureNameBoxController,
              lBox: globals.lHoldSetName,
              sizeHoldSet: sizeHoldSet),
          offset: Offset(offset!.dx, dyMeasureBoxName));
  
  Widget measureHeightWidget(BuildContext context,ZoomRoutesState state)=> Container(
      height: MediaQuery.of(context).size.height,
      width: 25.w,
      alignment: Alignment.center,
      color: colorBlack,
      child: Stack(
        children: [
          zoomWidget(
              offset: Offset(dxMeasureHeight, offset!.dy),
              isScaleByDx: false,
              context,
              scale: state.scale,
              _zoomMeasureController,
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context)
                      .size
                      .height,
                  width: 25.w,
                      child: MeasureHeightWidget(
                          scale: 1,
                          sizeHoldSet: sizeHoldSet,
                          row: row,
                          controller: _measureHeightController))),
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: 25.w,
                  color: Colors.transparent)
        ],
      ));
  

  Widget infoRouteWidget(BuildContext context, ZoomRoutesState state) =>
      zoomWidget(
          heightOfRoute: widget.heightOfRoute,
          isRoute: true,
          offset: offset,
          context,
          scale: state.scale,
          _zoomController,
          isLimitOffset: true,
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              alignment: Alignment.center,
              width: state.column * state.sizeHoldSet,
              decoration: BoxDecoration(gradient: gradientBackground()),
              child: routeWidget(context),
            ),
          ]));

  Widget optionWidget() => Container(
    color: colorBlack,
    padding: EdgeInsets.only(
        left: globals.contentPadding, right: globals.contentPadding, top: 5, bottom: 5),
    child: Row(
      children: [
        AppButton(
          shapeBorder: RoundedRectangleBorder(
              side: const BorderSide(color: colorWhite),
              borderRadius: BorderRadius.circular(50)),
          title: LocaleKeys.cancel.tr(),
          height: 32.h,
              textStyle: typoSmallTextRegular.copyWith(color: colorText0),
              onPress: () => _bloc.goBack(context),
            ),
            const Spacer(),
            InkWell(
                child: Container(
                  padding: EdgeInsets.only(
                      left: globals.contentPadding,
                      right: globals.contentPadding,
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
                    LocaleKeys.save_daft.tr(),
                    style: typoSmallTextRegular.copyWith(color: colorText0),
                  ),
                ),
                onTap: () =>
                    _bloc.saveDaftOnClick(context, widget.infoRouteModel,widget.model))
          ],
        ),
  );

  Widget routeWidget(BuildContext context) =>
      BlocBuilder<ZoomRoutesCubit, ZoomRoutesState>(
          bloc: _bloc,
          builder: (c, state) => GridView.builder(
              reverse: true,
              controller: _lBoxController,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.lHoldSet.length,
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
                        child: state.lHoldSet[index].fileName != null &&
                                state.lHoldSet[index].fileName!.isNotEmpty
                            ? RotatedBox(
                                quarterTurns: state.lHoldSet[index].rotate,
                                child: SizedBox(
                                    width: 8,
                                    child: AppNetworkImage(
                                        errorSource:
                                            '${ConstantKey.BASE_URL}hold/1/image',
                                        source: Utils.getUrlHoldSet(
                                            state.lHoldSet[index].id ?? 0))))
                            : const SizedBox()),
                  ),
                );
              }));

  Widget zoomWidget(
      BuildContext context, ZoomerController controller, Widget widget,
      {bool isScaleByDx = true,
          int? heightOfRoute,
          bool isLimitOffset = false,
        bool isRoute = false,
          Offset? offset,
          double scale = 4.0}) =>
      Zoomer(
          heightOfRoute: heightOfRoute,
          isRoute: isRoute,
          offset: offset,
          isLimitOffset: isLimitOffset,
          enableTranslation: true,
          controller: controller,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          enableRotation: false,
          background: const BoxDecoration(),
          clipRotation: true,
          maxScale: scale,
          minScale: scale,
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
      {bool isBackgroundCircle = true, bool isDisable = false}) =>
      Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
          child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Stack(children: [
                InkWell(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                            color: isDisable
                                ? colorGrey80
                                : (isBackgroundCircle
                                    ? colorWhite
                                    : Colors.transparent)),
                        child: SvgPicture.asset(icon,
                            color:
                                isBackgroundCircle ? colorBlack : colorWhite)),
                    onTap: () => onTab.call()),
                isDisable
                    ? Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height)
                    : const SizedBox()
              ])));

  Widget spaceMenu() => const SizedBox(width: 30);

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
      context: context,
      onPressed: () => _bloc.goBack(context),
      action: [
            BlocBuilder<ZoomRoutesCubit, ZoomRoutesState>(
                builder: (c, state) => state.currentIndex != null &&
                        state.lHoldSet[state.currentIndex!].fileName != null &&
                        state.lHoldSet[state.currentIndex!].fileName!.isNotEmpty
                    ? Row(mainAxisSize: MainAxisSize.min,
                        children: [
                          svgButton(context, Assets.svg.turnLeft,
                              () => _bloc.turnLeftOnClick(context),
                          /*    isDisable: state.lHoldSet[state.currentIndex ?? 0]
                                      .rotate ==
                                  -4*/),
                          const SizedBox(width: 10),
                          svgButton(context, Assets.svg.delete,
                              () => _bloc.deleteOnclick()),
                          const SizedBox(width: 10),
                          svgButton(context, Assets.svg.turnRight,
                              () => _bloc.turnRightOnClick(context),
                            /*  isDisable: state.lHoldSet[state.currentIndex ?? 0]
                                      .rotate ==
                                  4*/)
                        ],
                      )
                    : const SizedBox(),
                bloc: _bloc),
        const SizedBox(width: 10),
        svgButton(context, Assets.svg.threeD, () {},
            isBackgroundCircle: false),
        svgButton(context, Assets.svg.fullScreen, () =>_bloc.setScale(widget.heightOfRoute),
                isBackgroundCircle: false),
            svgButton(context, Assets.svg.more,
                () => _bloc.confirmOnclick(context, widget.infoRouteModel),
                isBackgroundCircle: false),
            SizedBox(width: globals.contentPadding)
          ]);
}
