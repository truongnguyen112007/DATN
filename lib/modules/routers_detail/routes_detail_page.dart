import 'dart:math';

import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/gen/assets.gen.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouterDetailPage extends StatefulWidget {
  final int index;
  final RoutesModel model;

  const RouterDetailPage({Key? key, required this.index, required this.model})
      : super(key: key);

  @override
  State<RouterDetailPage> createState() => _RouterDetailPageState();
}

class _RouterDetailPageState extends BasePopState<RouterDetailPage> {
  bool _turnOfO = true;
  final List<String> _xOrOList = [];
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
    var random = Random();
    for (int i = 0; i < 600; i++) {
      if (i % 19 == 0 || i % 15 == 0) {
        _xOrOList.add(lClimbing[random.nextInt(4)]);
      } else {
        _xOrOList.add('');
      }
    }
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return AppScaffold(
        appbar: appbar(context),
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
            Column(
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
                ))
              ],
            )
          ],
        ));
  }

  PreferredSizeWidget appbar(BuildContext context) => AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: colorText65,
          ),
          onPressed: () => RouterUtils.pop(context),
        ),
        title: AppText(
          widget.model.name,
          style: typoLargeTextRegular.copyWith(color: colorText65),
        ),
        backgroundColor: colorBlack,
        actions: const [
          Icon(
            Icons.more_vert,
            color: colorText65,
          )
        ],
      );

  Widget infoRoutesWidget(BuildContext context) => Row(
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
            itemCount: _xOrOList.length,
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
                      child: _xOrOList[index].isNotEmpty
                          ? Image.asset(
                              _xOrOList[index],
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
    setState(() {
      if (_turnOfO && _xOrOList[index] == '') {
        _xOrOList[index] = 'o';
      } else if (!_turnOfO && _xOrOList[index] == '') {
        _xOrOList[index] = 'o';
      }
      _turnOfO = !_turnOfO;
    });
  }

  @override
  int get tabIndex => widget.index;

  @override
  bool get isNewPage => true;
}
