import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_text_field.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/tab_home/tab_home_cubit.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../components/item_feed_widget.dart';
import '../../config/constant.dart';
import '../../data/model/feed_model.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends BaseState<TabHome>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final TabHomeCubit _bloc;

  @override
  void initState() {
    _bloc = TabHomeCubit();
    paging();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void paging() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (currentScroll >= (maxScroll * 0.9)) _bloc.getFeed(isPaging: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appbar: appBar(context),
        backgroundColor: colorBlack20,
        body: RefreshIndicator(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [nextClimbWidget(context), feedWidget()],
                ),
              ),
              BlocBuilder<TabHomeCubit, TabHomeState>(
                bloc: _bloc,
                builder: (BuildContext context, state) =>
                    (state.status == FeedStatus.initial ||
                            state.status == FeedStatus.refresh)
                        ? const Center(
                            child: AppCircleLoading(),
                          )
                        : const SizedBox(),
              )
            ],
          ),
          onRefresh: () async => _bloc.refresh(),
        ));
  }

  Widget feedWidget() => BlocBuilder<TabHomeCubit, TabHomeState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          Widget? widget;
          if (state.status == FeedStatus.initial ||
              state.status == FeedStatus.refresh) {
            widget = SizedBox();
          } else if (state.status == FeedStatus.success) {
            widget = ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              itemBuilder: (BuildContext context, int index) =>
                  (index == state.lFeed.length)
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.amber,
                        ))
                      : ItemFeed(
                          model: state.lFeed[index],
                          index: BottomNavigationConstant.TAB_HOME,
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

  Widget nextClimbWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<TabHomeCubit, TabHomeState>(
          bloc: _bloc,
          builder: (BuildContext context, state) => (state.status ==
                      FeedStatus.refresh ||
                  state.status == FeedStatus.initial)
              ? const SizedBox()
              : InkWell(
                  onTap: () {},
                  child: Container(
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.orange, Colors.red],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'NEXT CLIMB',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    '12:00 Tuesday, 23th March',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400),
                                    maxLine: 1,
                                  ),
                                  AppText(
                                    'Murall Krakowska, Warszawa',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12.sp),
                                    maxLine: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
