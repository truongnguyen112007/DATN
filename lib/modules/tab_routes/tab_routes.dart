import 'package:badges/badges.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/modules/designed/designed_page.dart';
import 'package:base_bloc/modules/favourite/favourite_page.dart';
import 'package:base_bloc/modules/history/history_page.dart';
import 'package:base_bloc/modules/playlist/playlist_page.dart';
import 'package:base_bloc/modules/tab_routes/tab_routes_cubit.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../components/check_login.dart';
import '../../data/globals.dart';
import '../../localization/locale_keys.dart';

class TabRoutes extends StatefulWidget {
  const TabRoutes({Key? key}) : super(key: key);

  @override
  State<TabRoutes> createState() => _TabRoutesState();
}

class _TabRoutesState extends State<TabRoutes>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final TabRouteCubit _bloc;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _bloc = TabRouteCubit();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: AppScaffold(
        resizeToAvoidBottomInset: false,
        appbar: homeAppbar(context, onClickSearch: () {
          _bloc.onClickSearch(context);
        }, onClickNotification: () {
          _bloc.onClickNotification(context);
        },
            onClickJumpToTop: () {},
            widget: AppText(
              LocaleKeys.routes.tr(),
              style: googleFont.copyWith(color: colorWhite,fontSize: 20.sp),
            )),
        backgroundColor: colorGreyBackground,
        body: BlocBuilder(
          bloc: _bloc,
          builder: (c, s) => !isLogin
              ? CheckLogin(
                  loginCallBack: () {
                    _bloc.onClickLogin(context);
                  },
                )
              : Column(
                  children: [
                    tabBar(context),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          PlayListPage(),
                          HistoryPage(),
                          FavouritePage(),
                          DesignedPage()
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget tabBar(BuildContext context) => Stack(
        children: [
          Container(
            color: colorBlack,
            child: TabBar(
              indicatorWeight: 3,
              indicatorColor: HexColor('FF5A00'),
              labelColor: HexColor('FF5A00'),
              unselectedLabelColor: colorGrey40,
              tabs: [
                Tab(text: LocaleKeys.playlist.tr()),
                Tab(text: LocaleKeys.history.tr()),
                Tab(text: LocaleKeys.favourite.tr()),
                Tab(text: LocaleKeys.designed.tr()),
              ],
              labelStyle: typoW400.copyWith(fontSize: 13.sp),
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 0.5,
              color: colorGrey50,
            ),
          ))
        ],
      );

  // PreferredSizeWidget appBar(BuildContext context) => appBarWidget(
  //       leading: SizedBox(),
  //       leadingWidth: contentPadding,
  //       titleStr: LocaleKeys.routes,
  //       action: [
  //         IconButton(
  //           onPressed: () {
  //             _bloc.onClickSearch(context);
  //           },
  //           icon: SvgPicture.asset(
  //             Assets.svg.search,
  //             color: colorSurfaceMediumEmphasis,
  //           ),
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(left: 10, right: contentPadding),
  //           child: Badge(
  //             gradient: LinearGradient(colors: [
  //               colorYellow70,
  //               colorPrimary,
  //               colorPrimary.withOpacity(0.65),
  //             ]),
  //             padding: const EdgeInsets.all(2),
  //             position: BadgePosition.topEnd(top: 13.h, end: 1.h),
  //             toAnimate: false,
  //             badgeContent: AppText(
  //               ' ',
  //               style: typoSmallTextRegular.copyWith(
  //                   fontSize: 9.sp, color: colorWhite),
  //             ),
  //             child: SvgPicture.asset(
  //               Assets.svg.notification,
  //               color: colorSurfaceMediumEmphasis,
  //             ),
  //           ),
  //         ),
  //       ],
  //       context: context,
  //     );

  @override
  bool get wantKeepAlive => true;
}
