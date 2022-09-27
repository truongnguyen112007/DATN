import 'dart:math';

import 'package:base_bloc/base/base_state.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final List<String> _lRoutes = [];
  final List<String> lClimbing = [
    Assets.png.climbing1.path,
    Assets.png.climbing2.path,
    Assets.png.climbing3.path,
    Assets.png.climbing4.path,
    Assets.png.climbing5.path
  ];
  final lHeight = [2, 4, 6, 8, 10, 12];

  @override
  void initState() {
    _bloc = RoutesDetailCubit();
    fakeData();
    super.initState();
  }

  void fakeData() {
    var random = Random();
    for (int i = 0; i < 600; i++) {
      if (i % 19 == 0 || i % 15 == 0) {
        _lRoutes.add(lClimbing[random.nextInt(4)]);
      } else {
        _lRoutes.add('');
      }
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        appbar: appBarWidget(
            context: context,
            action: const [
              Icon(
                Icons.more_vert,
                color: colorText65,
              )
            ],
            titleStr: widget.model.name),
        backgroundColor: colorBlack,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: colorBlack50,
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(color: colorWhite, blurRadius: 100)]),
              ),
            )),
            BlocBuilder<RoutesDetailCubit, RoutesDetailState>(
              builder: (c, state) => state.status == RoutesStatus.initial
                  ? const Center(
                      child: AppCircleLoading(),
                    )
                  : Column(
                      children: [
                        infoRoutesWidget(context),
                        Expanded(
                            child: Container(
                          alignment: Alignment.bottomCenter,
                          height: MediaQuery.of(context).size.height,
                          // margin: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(child: infoHeightWidget(context)),
                              Expanded(
                                child: routesWidget(context),
                              ),
                              const Expanded(
                                child: SizedBox(),
                              )
                            ],
                          ),
                        )),
                        actionWidget()
                      ],
                    ),
              bloc: _bloc,
            )
          ],
        ));
  }

  Widget infoRoutesWidget(BuildContext context) => Container(
        padding: const EdgeInsets.only(bottom: 15),
        color: colorBlack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            itemRoutesWidget(context, AppLocalizations.of(context)!.author,
                widget.model.grade, widget.model.status ?? '',
                padding: EdgeInsets.only(left: contentPadding, bottom: 10)),
            itemRoutesWidget(context, AppLocalizations.of(context)!.user,
                widget.model.grade, '',
                padding: const EdgeInsets.only(bottom: 10)),
            itemRoutesWidget(context, AppLocalizations.of(context)!.popularity,
                '100k', widget.model.author,
                padding: EdgeInsets.only(right: contentPadding, bottom: 10))
          ],
        ),
      );

  Widget itemRoutesWidget(
          BuildContext context, String title, String grade, String status,
          {EdgeInsetsGeometry? padding}) =>
      Padding(
        padding: padding ?? EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              title,
              style: typoSmallTextRegular.copyWith(color: colorText65),
            ),
            AppText(
              grade,
              style: typoLargeTextRegular.copyWith(color: colorText0),
            ),
            AppText(
              status,
              style: typoSmallTextRegular.copyWith(color: colorText65),
            )
          ],
        ),
      );

  Widget routesWidget(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height / 1.52,
        width: MediaQuery.of(context).size.width / 3,
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: _lRoutes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 12,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => _tapped(index),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: colorGrey70,
                      border: Border.all(color: colorGrey60, width: 1)),
                  child: Center(
                      child: _lRoutes[index].isNotEmpty
                          ? Image.asset(
                              _lRoutes[index],
                              width: 10,
                            )
                          : const SizedBox()),
                ),
              );
            }),
      );

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
                for (int i = lHeight.length - 1; i >= 0; i--)
                  heightWidget(lHeight[i])
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

  void _tapped(int index) {
/*    setState(() {
      if (_turnOfO && _lRoutes[index] == '') {
        _lRoutes[index] = 'o';
      } else if (!_turnOfO && _lRoutes[index] == '') {
        _lRoutes[index] = 'o';
      }
      _turnOfO = !_turnOfO;
    });*/
  }

  Widget actionWidget() => Container(
        padding: const EdgeInsets.only(bottom: 5),
        color: colorBlack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: itemActionWidget(AppLocalizations.of(context)!.info,
                    Icons.info, RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(AppLocalizations.of(context)!.share,
                    Icons.share, RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(AppLocalizations.of(context)!.copy,
                    Icons.copy, RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(
                    AppLocalizations.of(context)!.addToFavourite,
                    Icons.heart_broken_outlined,
                    RoutesAction.INFO)),
            Expanded(
                child: itemActionWidget(
                    AppLocalizations.of(context)!.addToPlaylist,
                    Icons.add_business_outlined,
                    RoutesAction.INFO))
          ],
        ),
      );

  Widget itemActionWidget(String title, IconData icon, RoutesAction action) =>
      InkWell(
        child: Column(
          children: [
            Icon(
              icon,
              color: colorText65,
            ),
            AppText(
              title,
              style: typoSmallTextRegular.copyWith(color: colorText65),
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        onTap: () => _bloc.handleAction(action),
      );

  @override
  int get tabIndex => widget.index;

  @override
  bool get isNewPage => true;
}
