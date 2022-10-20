import 'package:badges/badges.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/components/filter_widget.dart';
import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/history/history_cubit.dart';
import 'package:base_bloc/modules/history/history_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_circle_loading.dart';
import '../../components/item_feed_widget.dart';
import '../../components/message_tab_routes.dart';
import '../../localizations/app_localazations.dart';
import '../filter_routes/filter_routes_page.dart';
import '../tab_home/tab_home_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final HistoryCubit _bloc;

  @override
  void initState() {
    _bloc = HistoryCubit();
    paging();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  void paging() {
    if (_scrollController.hasClients) {
      _scrollController.addListener(() {
        if (!_scrollController.hasClients) return;
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        if (currentScroll >= (maxScroll * 0.9)) _bloc.getFeed(isPaging: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: colorGreyBackground,child: const MessageTabRoutes(),);
    //   RefreshIndicator(
    //   child: Stack(
    //     children: [
    //       SingleChildScrollView(
    //         controller: _scrollController,
    //         physics: const AlwaysScrollableScrollPhysics(),
    //         child: Column(
    //           children: [
    //             FilterWidget(
    //               selectCallBack: () {},
    //               filterCallBack: () => _bloc.filterOnclick(context),
    //               sortCallBack: () {},
    //             ),
    //             feedWidget()
    //           ],
    //         ),
    //       ),
    //       BlocBuilder<HistoryCubit, HistoryState>(
    //         bloc: _bloc,
    //         builder: (BuildContext context, state) =>
    //             (state.status == FeedStatus.initial ||
    //                     state.status == FeedStatus.refresh)
    //                 ? const Center(
    //                     child: AppCircleLoading(),
    //                   )
    //                 : const SizedBox(),
    //       )
    //     ],
    //   ),
    //   onRefresh: () async => _bloc.refresh(),
    // );
  }

  Widget feedWidget() => BlocBuilder<HistoryCubit, HistoryState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          Widget? widget;
          if (state.status == FeedStatus.initial ||
              state.status == FeedStatus.refresh) {
            widget = const SizedBox();
          } else if (state.status == FeedStatus.success) {
            widget = ListView.separated(
              padding: EdgeInsets.only(
                  top: contentPadding * 2,
                  left: contentPadding,
                  right: contentPadding),
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              itemBuilder: (BuildContext context, int index) =>
                  (index == state.lFeed.length)
                      ? const Center(child: AppCircleLoading())
                      : ItemFeed(
                          model: state.lFeed[index],
                          index: BottomNavigationConstant.TAB_ROUTES,
                        ),
              itemCount:
                  !state.readEnd ? state.lFeed.length + 1 : state.lFeed.length,
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 1,
              ),
            );
          }
          return widget!;
        },
      );

  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        backgroundColor: Colors.black,
        title: Text(AppLocalizations.of(context)!.climb),
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
