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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_circle_loading.dart';
import '../../gen/assets.gen.dart';
import '../../router/router_utils.dart';

class CreateRoutesPage extends StatefulWidget {
  const CreateRoutesPage({Key? key}) : super(key: key);

  @override
  State<CreateRoutesPage> createState() => _CreateRoutesPageState();
}

class _CreateRoutesPageState extends BasePopState<CreateRoutesPage> {
  late CreateRoutesCubit _bloc;
  final ZoomerController _zoomController = ZoomerController(initialScale: 1.0);

  @override
  void initState() {
    _bloc = CreateRoutesCubit();
    _bloc.setData(width: 300, height: 1300, size: 20);
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
      appbar: appbar(context),
      body: Column(
        children: [
          Expanded(
              child: BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
            builder: (c, state) => state.status == StatusType.initial
                ? const Center(
                    child: AppCircleLoading(),
                  )
                : Row(
                    children: [routesWidget(context)],
                  ),
            bloc: _bloc,
          )),
          actionWidget()
        ],
      ),
    );
  }

  Widget infoHeightWidget(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* for (int i = lHeight.length - 1; i >= 0; i--)
                  heightWidget(lHeight[i])*/
              ],
            )),
            Image.asset(
              Assets.png.person.path,
              height: 80.w, fit: BoxFit.fitHeight,
              // height: 10,
            )
          ],
        ),
      );

  Widget heightWidget(int height) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText('${height}m ',
              style: typoSmallTextRegular.copyWith(color: colorText65)),
          AppText(
            "-------",
            style: typoMediumTextRegular.copyWith(
                color: colorText65, letterSpacing: 5),
          )
        ],
      );

  Widget actionWidget() => Container(
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

  Widget routesWidget(BuildContext context) => Zoomer(
        enableTranslation: true,
        controller: _zoomController,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        enableRotation: true,
        background: const BoxDecoration(),
        clipRotation: true,
        maxScale: 10,
        minScale: 1,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            BlocBuilder<CreateRoutesCubit, CreateRoutesState>(
                bloc: _bloc,
                builder: (c, state) => GridView.builder(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3,
                        right: MediaQuery.of(context).size.width / 3),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.lBox.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: state.row,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onLongPress: () =>
                            _bloc.itemOnLongPress(index, context),
                        onTap: () => _bloc.itemOnClick(index),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: colorGrey70,
                              border: Border.all(
                                  color: state.selectIndex == index
                                      ? colorOrange100
                                      : colorGrey60,
                                  width: 1)),
                          child: Center(
                              child: state.lBox[index].isNotEmpty
                                  ? Image.asset(
                                      state.lBox[index],
                                      width: 10,
                                    )
                                  : const SizedBox()),
                        ),
                      );
                    }))
          ],
        ),
      );

  void _tapped(int index) {
    setState(() {
      // _lRoutes[index] = lClimbing[Random().nextInt(5)];
    });
  }

  PreferredSizeWidget appbar(BuildContext context) =>
      appBarWidget(context: context, action: [
        const Icon(
          Icons.threed_rotation,
          color: colorText45,
        ),
        const SizedBox(
          width: 30,
        ),
        const Icon(
          Icons.fit_screen_outlined,
          color: colorText45,
        ),
        const SizedBox(
          width: 30,
        ),
        const Icon(
          Icons.more_vert,
          color: colorText45,
        ),
        SizedBox(
          width: contentPadding,
        )
      ]);

  @override
  bool get isNewPage => true;

  @override
  int get tabIndex => BottomNavigationConstant.TAB_ROUTES;
}
