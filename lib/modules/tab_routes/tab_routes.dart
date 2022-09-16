import 'package:badges/badges.dart';
import 'package:base_bloc/modules/designed/designed_page.dart';
import 'package:base_bloc/modules/favourite/favourite_page.dart';
import 'package:base_bloc/modules/history/history_page.dart';
import 'package:base_bloc/modules/playlist/playlist_page.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../localizations/app_localazations.dart';

class TabRoutes extends StatefulWidget {
  const TabRoutes({Key? key}) : super(key: key);

  @override
  State<TabRoutes> createState() => _TabRoutesState();
}

class _TabRoutesState extends State<TabRoutes>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: AppScaffold(
          appbar: appBar(context),
          backgroundColor: colorGrey90,
          body: Column(
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
              ))
            ],
          ),
        ));
  }

  Widget tabBar(BuildContext context) => Stack(
        children: [
        Container(color: colorBlack,child:   TabBar(
          indicatorColor: colorOrange100,
          labelColor: colorOrange100,
          unselectedLabelColor: colorText20,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!.playlist,
            ),
            Tab(
              text: AppLocalizations.of(context)!.history,
            ),
            Tab(
              text: AppLocalizations.of(context)!.favourite,
            ),
            Tab(
              text: AppLocalizations.of(context)!.designed,
            ),
          ],
          labelStyle: typoSmallTextRegular.copyWith(color: colorText20),
        ),),
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

  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        backgroundColor: colorBlack,
        // bottom: tabBar(context),
        title: Text(AppLocalizations.of(context)!.routes),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          SizedBox(
            width: 15.w,
          ),
          SizedBox(
            child: Badge(
              padding: const EdgeInsets.all(2),
              position: BadgePosition.topEnd(top: 13.h, end: -2.h),
              toAnimate: false,
              badgeContent: const Text('1'),
              child: const Icon(Icons.notifications_none_sharp),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
        ],
      );

  @override
  bool get wantKeepAlive => true;
}
