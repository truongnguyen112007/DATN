import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_button.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/components/zoomer.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/create_routes/create_routes_cubit.dart';
import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/hex_color.dart';
import '../../components/app_circle_loading.dart';
import '../../gen/assets.gen.dart';
import '../../router/router_utils.dart';
import '../../utils/app_utils.dart';

class CreateRoutesPage extends StatefulWidget {
  const CreateRoutesPage({Key? key}) : super(key: key);

  @override
  State<CreateRoutesPage> createState() => _CreateRoutesPageState();
}

class _CreateRoutesPageState extends BasePopState<CreateRoutesPage> {
  late CreateRoutesCubit _bloc;
  final ZoomerController _zoomController = ZoomerController(initialScale: 1.0);
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
  final lHeight = [0, 2, 4, 6, 8, 10, 12];

  @override
  void initState() {
    _bloc = CreateRoutesCubit();
    _bloc.setData(row: row, column: column, sizeHoldSet: sizeHoldSet);
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      backgroundColor: HexColor('212121'),
      appbar: appbar(context),
      body: BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
        builder: (c, state) => state.status == StatusType.initial
            ? const Center(
                child: AppCircleLoading(),
              )
            : Column(
                children: [
                  Expanded(
                      child: Stack(
                    children: [
                      blurBackground(context),
                      zoomWidget(
                          context,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  width: state.sizeHoldSet * state.column * 1.8,
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        lineGreyGradient(context, false, state),
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
                                                height: state.sizeHoldSet * 1.5,
                                              )
                                            ],
                                          ),
                                        ),
                                        lineGreyGradient(context, true, state),
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
                                            height: state.row *
                                                    state.sizeHoldSet /
                                                    6 +
                                                2.h),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 7.h,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color:
                                          HexColor('6B6B6B').withOpacity(0.05),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          )),
                     /* Align(
                          alignment: Alignment.bottomLeft,
                          child: infoHeightWidget(context))*/
                    ],
                  )),
                  optionWidget()
                ],
              ),
        bloc: _bloc,
      ),
    );
  }

  Widget infoHeightWidget(BuildContext context) =>
      BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
          builder: (c, state) => Container(
                height: MediaQuery.of(context).size.height,
                width: 20,
                color: colorBlack,
                alignment: Alignment.bottomLeft,
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (c, index) => Container(
                          width: 5,
                          height: 1,
                          color: colorWhite,
                        ),
                    separatorBuilder: (c, index) => SizedBox(
                          height: state.sizeHoldSet,
                        ),
                    itemCount: state.row),
              ),
          bloc: _bloc);

  Widget blurBackground(BuildContext context) => Positioned.fill(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 40,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(color: colorWhite, blurRadius: 100)
              ]))));

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

  Widget lineGreyGradient(
          BuildContext context, bool isLeft, CreateRoutesState state) =>
      Stack(
        children: [
          Container(
            // height: state.row * state.sizeHoldSet,
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

  Widget routesWidget(BuildContext context) => BlocBuilder<CreateRoutesCubit,
          CreateRoutesState>(
      bloc: _bloc,
      builder: (c, state) => SizedBox(
            width: state.column * state.sizeHoldSet,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.lRoutes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: state.column, childAspectRatio: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onLongPress: () => _bloc.itemOnLongPress(index, context),
                    onTap: () => _bloc.itemOnClick(index),
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
                                      width: 10,
                                    ),
                                    shaderCallback: (Rect bounds) =>
                                        Utils.backgroundGradientOrangeButton()
                                            .createShader(const Rect.fromLTRB(
                                                0, 0, 10, 10)),
                                  ),
                                )
                              : const SizedBox()),
                    ),
                  );
                }),
          ));

  Widget zoomWidget(BuildContext context, Widget widget) => Zoomer(
        enableTranslation: true,
        scaleCallBack: (value) {
          logE("TAG SCALE CALLBACK: $value");
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

  Widget spaceMenu() => const SizedBox(width: 30);

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, action: [
        BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
          builder: (c, state) => state.selectIndex != null &&
                  state.lRoutes[state.selectIndex!].holdSet.isNotEmpty
              ? svgButton(context, Assets.svg.turnLeft,
                  () => _bloc.turnLeftOnClick(context))
              : const SizedBox(),
          bloc: _bloc,
        ),
        const SizedBox(width: 10),
        BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
          builder: (c, state) => state.selectIndex != null &&
                  state.lRoutes[state.selectIndex!].holdSet.isNotEmpty
              ? svgButton(
                  context, Assets.svg.delete, () => _bloc.deleteOnclick())
              : const SizedBox(),
          bloc: _bloc,
        ),
        const SizedBox(width: 10),
        BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
          builder: (c, state) => state.selectIndex != null &&
                  state.lRoutes[state.selectIndex!].holdSet.isNotEmpty
              ? svgButton(context, Assets.svg.turnRight,
                  () => _bloc.turnRightOnClick(context))
              : const SizedBox(),
          bloc: _bloc,
        ),
        const SizedBox(width: 10),
        svgButton(context, Assets.svg.threeD, () {}, isBackgroundCircle: false),
        svgButton(context, Assets.svg.fullScreen, () {},
            isBackgroundCircle: false),
        svgButton(context, Assets.svg.more, () {}, isBackgroundCircle: false),
        SizedBox(width: contentPadding)
      ]);

  @override
  bool get isNewPage => true;

  @override
  int get tabIndex => BottomNavigationConstant.TAB_ROUTES;
}
