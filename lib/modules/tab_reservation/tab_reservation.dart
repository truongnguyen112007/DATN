import 'package:badges/badges.dart';
import 'package:base_bloc/base/hex_color.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_cubit.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_circle_loading.dart';
import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../components/item_feed_widget.dart';
import '../../config/constant.dart';
import '../../data/model/reservation_model.dart';
import '../../localizations/app_localazations.dart';
import '../../theme/colors.dart';
import '../tab_home/tab_home_state.dart';

class TabReservation extends StatefulWidget {
  const TabReservation({Key? key}) : super(key: key);

  @override
  State<TabReservation> createState() => _TabReservationState();
}

class _TabReservationState extends State<TabReservation>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final TabReservationCubit _bloc;

  @override
  void initState() {
    _bloc = TabReservationCubit();
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
    return AppScaffold(
        appbar: appbar(context),
        backgroundColor: colorBlack30,
        body: RefreshIndicator(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [reservationWidget()],
                ),
              ),
              BlocBuilder<TabReservationCubit, TabReservationState>(
                bloc: _bloc,
                builder: (BuildContext context, state) =>
                    (state.status == StatusType.initial ||
                            state.status == StatusType.refresh)
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

  PreferredSizeWidget appbar(BuildContext context) => appBarWidget(
          leading: const SizedBox(),
          automaticallyImplyLeading: false,
          context: context,
          titleStr: AppLocalizations.of(context)!.reservations,
          action: [
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
              width: contentPadding,
            ),
          ]);

  Widget reservationWidget() =>
      BlocBuilder<TabReservationCubit, TabReservationState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          Widget? widget;
          if (state.status == StatusType.initial ||
              state.status == StatusType.refresh) {
            widget = const SizedBox();
          } else if (state.status == StatusType.success) {
            widget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titleWidget(AppLocalizations.of(context)!.today),
                lReservationWidget(state.lToday),
                titleWidget(AppLocalizations.of(context)!.tomorrow),
                lReservationWidget(state.lTomorrow),
                titleWidget(AppLocalizations.of(context)!.nextWeek),
                lReservationWidget(state.lNextWeek),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          }
          return widget!;
        },
      );

  Widget titleWidget(String content) => Padding(
        padding: EdgeInsets.only(left: contentPadding, top: 10, bottom: 3),
        child: AppText(
          content.toUpperCase(),
          style: typoSmallTextRegular.copyWith(color: colorText55),
        ),
      );

  Widget lReservationWidget(List<ReservationModel> list) => ListView.separated(
        padding: EdgeInsets.only(left: contentPadding, right: contentPadding),
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemBuilder: (BuildContext context, int index) => (index == list.length)
            ? const Center(child: AppCircleLoading())
            : itemReservation(list[index]),
        itemCount: list.length,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
      );

  Widget itemReservation(ReservationModel model) => Container(
        padding: EdgeInsets.only(
            top: 10, bottom: 10, left: contentPadding + contentPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: colorBlack90),
        child: InkWell(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: contentPadding + 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        colors: model.isCheck
                            ? [colorGrey37, colorGrey37]
                            : [colorOrange50, colorOrange90],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                height: 60.w,
                width: 60.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      Utils.convertDateTimeToEEE(model.calendar),
                      style: typoSmallTextRegular.copyWith(color: colorText10),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    AppText(
                      Utils.convertDateTimeToDD(model.calendar),
                      style: typoLargeTextRegular.copyWith(
                          color: colorText7, fontSize: 23.sp),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '${model.startTime} - ${model.endTime}',
                    style: typoLargeTextRegular.copyWith(
                        color: colorText30, fontSize: 23.sp),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      AppText(
                        ' ${model.status}',
                        style:
                            typoSmallTextRegular.copyWith(color: colorText67),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: colorGrey35,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      Expanded(
                          child: AppText(
                        ' ${model.status}',
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            typoSmallTextRegular.copyWith(color: colorText67),
                      ))
                    ],
                  )
                ],
              ))
            ],
          ),
          onTap: () => _bloc.itemOnclick(model),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
