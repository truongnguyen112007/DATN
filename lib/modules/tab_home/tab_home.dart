import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/components/item_loading.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/tab_home/tab_home_cubit.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/router/router.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../components/item_feed_widget.dart';
import '../../config/constant.dart';
import '../../gen/assets.gen.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> with AutomaticKeepAliveClientMixin {
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
    _bloc.close();
    super.dispose();
  }

  void paging() {
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (currentScroll >= (maxScroll * 0.9)) _bloc.getFeed(isPaging: true);
    });
  }

  void jumToTop() => _scrollController.animateTo(0,
      duration: const Duration(seconds: 2),
      curve: Curves.fastLinearToSlowEaseIn);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        padding: EdgeInsets.only(left: 7.w, right: 7.w),
        appbar: appbar(context),
        backgroundColor: colorGreyBackground,
        body: RefreshIndicator(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    itemSpace(),
                    nextClimbWidget(context),
                    itemSpace(),
                    feedWidget()
                  ],
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
            widget = const SizedBox();
          } else if (state.status == FeedStatus.success) {
            widget = ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              itemBuilder: (BuildContext context, int index) =>
                  (index == state.lFeed.length)
                      ? const ItemLoading()
                      : ItemFeed(
                          model: state.lFeed[index],
                          index: BottomNavigationConstant.TAB_HOME,
                        ),
              itemCount:
                  !state.readEnd ? state.lFeed.length + 1 : state.lFeed.length,
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  itemSpace(),
            );
          }
          return widget!;
        },
      );

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
          leading: const SizedBox(),
          backgroundColor: colorMainBackground,
          landingWidth: contentPadding,
          context: context,
          title: InkWell(
            onTap: (){
              jumToTop();
            },
            child: SvgPicture.asset(
              Assets.svg.relimbDark,
              height: 24,
            ),
          ),
          action: [
            IconButton(
              onPressed: () => _bloc.searchOnclick(context),
              icon: SvgPicture.asset(
                Assets.svg.search,
                color: colorSurfaceMediumEmphasis,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: contentPadding),
              child: Badge(
                gradient: LinearGradient(colors: [
                  colorYellow70,
                  colorPrimary,
                  colorPrimary.withOpacity(0.65),
                ]),
                padding: const EdgeInsets.all(2),
                position: BadgePosition.topEnd(top: 13.h, end: 1.h),
                toAnimate: false,
                badgeContent: AppText(
                  '1',
                  style: typoSmallTextRegular.copyWith(
                      fontSize: 9.sp, color: colorWhite),
                ),
                child: SvgPicture.asset(
                  Assets.svg.notification,
                  color: colorSurfaceMediumEmphasis,
                ),
              ),
            ),
          ]);

  Widget itemSpace({double height = 10}) => SizedBox(
        height: height,
      );

  Widget nextClimbWidget(BuildContext context) =>
      BlocBuilder<TabHomeCubit, TabHomeState>(
        bloc: _bloc,
        builder: (BuildContext context, state) => (state.status ==
                    FeedStatus.refresh ||
                state.status == FeedStatus.initial)
            ? const SizedBox()
            : InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 84.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        HexColor('FF9300'),
                        HexColor('FF5A00'),
                        HexColor('FF5A00')
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AppText(
                            LocaleKeys.nextClimb.toUpperCase(),
                            style: typoSuperSmallTextRegular.copyWith(
                                fontSize: 9.sp,
                                color: colorText0.withOpacity(0.87)),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 6,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: AppText(
                                        '12:00 Tuesday, 23th March',
                                        style: typoLargeTextRegular.copyWith(
                                            fontSize: 20.2.sp,
                                            color:
                                                colorText90.withOpacity(0.65)),
                                        maxLine: 1,
                                      ),
                                    ),
                                    Positioned.fill(
                                        child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: AppText(
                                        'Murall Krakowska, Warszawa',
                                        style:
                                            typoSuperSmallTextRegular.copyWith(
                                                fontSize: 13.sp,
                                                color: colorText90
                                                    .withOpacity(0.6)),
                                        maxLine: 1,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
      );

  @override
  bool get wantKeepAlive => true;
}
