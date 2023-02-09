import 'dart:async';
import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_network_image.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/components/zoomer.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart' as globals;
import 'package:base_bloc/data/model/hold_set_model.dart';
import 'package:base_bloc/data/model/info_route_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/create_routes/create_routes_cubit.dart';
import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../base/hex_color.dart';
import '../../components/app_circle_loading.dart';
import '../../data/eventbus/list_hold_set_event.dart';
import '../../data/globals.dart';
import '../../gen/assets.gen.dart';
import '../../localization/locale_keys.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';

class CreateRoutesPage extends StatefulWidget {
  final RoutesModel? model;
  final bool? isEdit;
  final InfoRouteModel? infoRouteModel;

  const CreateRoutesPage(
      {Key? key, this.model, this.isEdit, this.infoRouteModel})
      : super(key: key);

  @override
  State<CreateRoutesPage> createState() => _CreateRoutesPageState();
}

class _CreateRoutesPageState extends BasePopState<CreateRoutesPage>   with TickerProviderStateMixin {
  late CreateRoutesCubit _bloc;
  final ZoomerController _zoomController = ZoomerController(initialScale: 1.0);
  var sizeHoldSet = 8.6.h;
  var row = 47;
  final column = 12;
  final List<String> lHoldSet = [
    Assets.svg.holdset1,
    Assets.svg.holdset2,
    Assets.svg.holdset3,
    Assets.svg.holdset4,
    Assets.svg.holdset5,
    Assets.svg.holdset6,
  ];
  StreamSubscription<ListHoldSetEvent>? _lHoldSetStream;
  late final AnimationController _animationController1 =
      AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
  late final Animation<double> _animation1 =
      CurvedAnimation(parent: _animationController1, curve: Curves.easeInSine);

  late final AnimationController _animationController2 =
      AnimationController(duration: const Duration(milliseconds: 1100), vsync: this);
  late final Animation<double> _animation2 =
      CurvedAnimation(parent: _animationController2, curve: Curves.easeInSine);

  late final AnimationController _animationController3 = AnimationController(
      duration: const Duration(milliseconds: 1100), vsync: this);
  late final Animation<double> _animation3 =
      CurvedAnimation(parent: _animationController3, curve: Curves.easeInSine);
  var step = 1;

  @override
  void initState() {
    _bloc = CreateRoutesCubit();
    checkRow();
    _lHoldSetStream = Utils.eventBus.on<ListHoldSetEvent>().listen(
        (model) => _bloc.setHoldSets(model.holdSet, model.holdSetIndex));
    _bloc.setData(
        infoRouteModel: widget.infoRouteModel,
        row: row,
        isEdit: widget.isEdit,
        column: column,
        sizeHoldSet: sizeHoldSet,
        lHoldSetImage: lHoldSet,
        model: widget.model);
    Timer(const Duration(seconds: 1), () => _animationController1.forward());
    super.initState();
  }

  void checkRow() {
    if(widget.model!=null){
      row = widget.model!.height! * 5;
      switch (widget.model!.height) {
        case 12:
          sizeHoldSet = 7.5.h;
          return;
        case 9:
          sizeHoldSet = 8.6.h;
          return;
        case 6:
        case 3:
          sizeHoldSet = 8.8.h;
          return;
      }
    }
    if (widget.infoRouteModel != null) {
      row = widget.infoRouteModel!.height * 5;
      switch (widget.infoRouteModel!.height) {
        case 12:
          sizeHoldSet = 7.5.h;
          return;
        case 9:
          sizeHoldSet = 8.6.h;
          return;
        case 6:
        case 3:
          sizeHoldSet = 8.8.h;
          return;
      }
    }
  }

  @override
  void dispose() {
    _lHoldSetStream?.cancel();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: HexColor('212121'),
      appbar: appbar(context),
      body: BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
        builder: (c, state) => state.status == StatusType.initial
            ? const Center(child: AppCircleLoading())
            : Stack(
                children: [
                  Column(
                    children: [
                      line(),
                      measureNameWidget(),
                      Expanded(
                          child: Stack(children: [
                        blurBackground(context),
                        Row(
                          children: [
                            measureWidget(),
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    width:
                                        state.sizeHoldSet * state.column * 1.8,
                                    height: 18.h,
                                    color: HexColor('898989')),
                                SizedBox(
                                    width:
                                        state.sizeHoldSet * state.column * 1.66,
                                    child: Image.asset(Assets.png.tesst.path)),
                                Expanded(
                                    child: Stack(
                                  children: [
                                    Positioned.fill(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          wallWidget(context, false, state),
                                          Container(
                                            decoration: BoxDecoration(
                                                gradient: gradientBackground()),
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    width: state.column *
                                                            state.sizeHoldSet +
                                                        16.w,
                                                    height: 2,
                                                    color: HexColor('A3A3A3')),
                                                Container(
                                                    width: state.column *
                                                            state.sizeHoldSet +
                                                        16.w,
                                                    height: 5,
                                                    color: colorBlack),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    heightWidget(true),
                                                    Container(
                                                      width: state.column *
                                                          state.sizeHoldSet,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              gradientBackground()),
                                                      child: Column(
                                                        children: [
                                                          nameHoldSetWidget(
                                                              context),
                                                          routesWidget(context),
                                                          nameHoldSetWidget(
                                                              context),
                                                        ],
                                                      ),
                                                    ),
                                                    heightWidget(false),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        state.sizeHoldSet * 1.5)
                                              ],
                                            ),
                                          ),
                                          wallWidget(context, true, state),
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
                                          child: SvgPicture.asset(
                                              Assets.svg.man,
                                              height: 60),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                Container(
                                  height: 4.h,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: HexColor('6B6B6B')
                                          .withOpacity(0.05),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    )
                                  ]),
                                )
                              ],
                            )),
                            const SizedBox(width: 20)
                          ],
                        ),
                      ])),
                      optionWidget()
                    ],
                  ),
                  state.isShowGuideline
                      ? guidelineWidget(context)
                      : const SizedBox()
                ],
              ),
        bloc: _bloc,
      ),
    );
  }

  Widget guidelineWidget(BuildContext context) {
    return InkWell(
        child: Container(
          padding: EdgeInsets.only(left: 30.w),
          color: colorBlack.withOpacity(0.7),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                    padding: EdgeInsets.only(right: 30.w),
                    child: FadeTransition(
                      opacity: _animation1,
                      child: AppText(LocaleKeys.edit_route.tr(),
                          style: typoW700.copyWith(fontSize: 29.sp)),
                    )),
              ),
              const Spacer(),
              space(),
              itemGuideline(
                  LocaleKeys.tab_on_cell_to_select_hold.tr(),
                  LocaleKeys.briefly_touch_surface_with_fingertip.tr(),
                  Assets.svg.hand,
                  animation: _animation1),
              space(height: 30),
              itemGuideline(
                  LocaleKeys.press_cell_with_hold_to_move_it_or_rotate_it.tr(),
                  LocaleKeys.touch_suface_for_extended_privod_of_time.tr(),
                  Assets.svg.hand,
                  animation: _animation2),
              space(height: 30),
              itemGuideline(
                  LocaleKeys.pinch_to_scale_down_and_up.tr(),
                  LocaleKeys
                      .touch_surface_with_two_fingers_and_bring_them_closer_together
                      .tr(),
                  Assets.svg.doubleHands,
                  iconWidth: 98.w,
                  animation: _animation3),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                      mainAxisSize: MainAxisSize
                          .min,
                      children: [
                        InkWell(
                            child: Container(margin: EdgeInsets.only(bottom: 10,right: contentPadding),
                              padding: EdgeInsets.only(
                                  left: globals.contentPadding,
                            right: globals.contentPadding,
                            top: 5,
                            bottom: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colorBlack,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: colorWhite)),
                              height: 32.h,
                              child: AppText(
                               "   "+ LocaleKeys.skip.tr()+' >> ',
                                style: typoSmallTextRegular.copyWith(
                                    color: colorText0),
                              ),
                            ),
                          onTap: () => _bloc.showGuideline(false),
                        )
                      ]))
            ],
          ),
        ),
        onTap: () => nextStep());
  }

  void nextStep() {
    step++;
    switch (step) {
      case 1:
        _animationController1.forward();
        return;
      case 2:
        _animationController2.forward();
        return;
      case 3:
        _animationController3.forward();
        return;
      default:
        _bloc.showGuideline(false);
    }
  }

  Widget animationWidget(bool isVisible, Widget child) => AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          width: 200.0,
          height: 200.0,
          color: Colors.green,
        ),
      );

  Widget itemGuideline(String title, String content, String icon,
          {double? iconWidth,
            required Animation<double> animation}) =>
      FadeTransition(
        opacity: animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title, style: typoW400.copyWith(fontSize: 14.sp)),
            space(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(icon, width: iconWidth ?? 47.w),
                spaceMenu(),
                AppText(content,
                    style:
                        typoW400.copyWith(color: colorText0.withOpacity(0.6)))
              ],
            )
          ],
        ),
      );

  Widget line() => Container(
      height: 0.3,
      width: MediaQuery.of(context).size.width,
      color: colorGreyBackground);

  Widget measureWidget() => Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 4.h + 4.sp + sizeHoldSet * 1.5),
      height: MediaQuery.of(context).size.height,
      width: 20.w,
      color: colorBlack,
      child: ListView.builder(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: row,
          itemBuilder: (BuildContext context, int index) => Container(
              height: sizeHoldSet,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(' ${index + 1}',
                      style: typoW600.copyWith(
                          fontSize: 8.sp,
                          color: (index == 3 || index % 3 == 0)
                              ? colorText0.withOpacity(0.8)
                              : Colors.transparent)),
                  Container(
                      margin: const EdgeInsets.only(left: 3),
                      width: 3,
                      height: 1,
                      color: HexColor('5E5E5E'))
                ],
              ))));

  Widget measureNameWidget() => Container(
      height: 18.h,
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      color: colorBlack,
      child: ListView.builder(
          itemCount: globals.lHoldSetName.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (c, i) => Container(
              alignment: Alignment.bottomCenter,
              width: sizeHoldSet,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(globals.lHoldSetName[i],
                      style: typoW600.copyWith(
                          fontSize: 8.sp,
                          color: i % 2 == 0
                              ? colorWhite.withOpacity(0.87)
                              : Colors.transparent)),
                  Container(height: 3, width: 0.7, color: colorWhite)
                ],
              ))));

  Widget blurBackground(BuildContext context) => Positioned.fill(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 40,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(color: colorWhite, blurRadius: 100)
              ]))));

  Widget nameHoldSetWidget(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < globals.lHoldSetName.length; i++)
            AppText(globals.lHoldSetName[i],
                style: typoW400.copyWith(fontSize: 4.sp, height: 1))
        ],
      );

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

  Widget wallWidget(
          BuildContext context, bool isLeft, CreateRoutesState state) =>
      Stack(
        children: [
          Container(
              width: 22.w,
              decoration: BoxDecoration(gradient: gradientBackground())),
          Positioned.fill(
              child: Align(
                  alignment:
                      isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(width: 5.w, color: HexColor('FF5A00'))))
        ],
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
            AppText(status,
                style: typoW400.copyWith(
                    fontSize: 12.5.sp, color: colorText0.withOpacity(0.87)))
          ],
        ),
      );

  Widget optionWidget() => Container(
        color: colorBlack,
        padding: EdgeInsets.only(
            left: globals.contentPadding,
            right: globals.contentPadding,
            top: 5,
            bottom: 5),
        child: Row(
          children: [
            AppButton(
              shapeBorder: RoundedRectangleBorder(
                  side: const BorderSide(color: colorWhite),
                  borderRadius: BorderRadius.circular(50)),
              title: LocaleKeys.cancel.tr(),
              height: 32.h,
              textStyle: typoSmallTextRegular.copyWith(color: colorText0),
              onPress: () => RouterUtils.pop(context),
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
                    color: Colors.cyan,
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

  Widget routesWidget(BuildContext context) =>
      BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
          bloc: _bloc,
          builder: (c, state) => GridView.builder(
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.lHoldSet.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: state.column, childAspectRatio: 1.0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onLongPress: () => _bloc.itemOnLongPress(index, context),
                  onTap: () => _bloc.itemOnClick(
                      index,
                      widget.infoRouteModel?.height ??
                          widget.model?.height ??
                          9,
                      context,
                      widget.infoRouteModel),
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: state.selectIndex == index
                                ? colorOrange100
                                : colorGrey60,
                            width: state.selectIndex == index ? 1 : 0.5)),
                    child: Center(
                        child: state.lHoldSet[index].fileName != null &&
                                state.lHoldSet[index].fileName!.isNotEmpty
                            ? RotatedBox(
                                quarterTurns: state.lHoldSet[index].rotate,
                                child: AppNetworkImage(
                                    errorSource:
                                        '${ConstantKey.BASE_URL}hold/1/image',
                                    source: (state.lHoldSet[index].fileName ??
                                                '')
                                            .startsWith('http')
                                        ? (state.lHoldSet[index].fileName ?? '')
                                        : Utils.getUrlHoldSet(
                                            state.lHoldSet[index].id ?? 0)))
                            : const SizedBox()),
                  ),
                );
              }));

  Widget zoomWidget(BuildContext context, Widget widget) => Zoomer(
        enableTranslation: true,
        scaleCallBack: (value) {
          // logE("TAG SCALE CALLBACK: $value");
        },
        controller: _zoomController,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        enableRotation: false,
        background: const BoxDecoration(),
        clipRotation: true,
        maxScale: 10,
        minScale: 1,
        child: widget,
      );

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
                    color:
                        isBackgroundCircle ? colorWhite : Colors.transparent),
                child: SvgPicture.asset(icon,
                    color: isBackgroundCircle ? colorBlack : colorWhite),
              ),
              onTap: () => onTab.call()),
        ),
      );

  Widget space({double height =10})=>SizedBox(height: height);

  Widget spaceMenu() => const SizedBox(width: 30);

  Widget editRotateWidget(String icon, VoidCallback callback) =>
      BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
        builder: (c, state) => state.selectIndex != null &&
                state.lHoldSet[state.selectIndex!].holdSet.isNotEmpty
            ? svgButton(context, Assets.svg.turnLeft,
                () => _bloc.turnLeftOnClick(context))
            : const SizedBox(),
        bloc: _bloc,
      );

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, action: [
        editRotateWidget(
            Assets.svg.turnLeft, () => _bloc.turnLeftOnClick(context)),
        const SizedBox(width: 10),
        editRotateWidget(Assets.svg.delete, () => _bloc.deleteOnclick()),
        const SizedBox(width: 10),
        editRotateWidget(
            Assets.svg.turnRight, () => _bloc.turnRightOnClick(context)),
        const SizedBox(width: 10),
        svgButton(context, Assets.svg.threeD, () {}, isBackgroundCircle: false),
        svgButton(
            context,
            Assets.svg.fullScreen,
            () => _bloc.scaleOnClick(
                context,
                widget.model?.height ?? widget.infoRouteModel!.height,
                widget.infoRouteModel),
            isBackgroundCircle: false),
        svgButton(context, Assets.svg.more, () => _bloc.confirmOnclick(context,widget.infoRouteModel),
            isBackgroundCircle: false),
        SizedBox(width: globals.contentPadding)
      ]);

  @override
  bool get isNewPage => true;

  @override
  int get tabIndex => BottomNavigationConstant.TAB_RECEIPT;
}
