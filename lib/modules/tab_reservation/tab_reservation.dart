import 'package:badges/badges.dart';
import 'package:base_bloc/components/appbar_widget.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_cubit.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_state.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/app_circle_loading.dart';
import '../../components/app_scalford.dart';
import '../../components/app_text.dart';
import '../../components/check_login.dart';
import '../../components/feeture_under_widget.dart';
import '../../data/model/reservation_model.dart';
import '../../gen/assets.gen.dart';
import '../../localizations/app_localazations.dart';
import '../../theme/colors.dart';

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: addWidget(context),
      appbar: homeAppbar(context, onClickSearch: () {
        _bloc.onClickSearch(context);
      },
          onClickNotification: () {
        _bloc.onClickNotification(context);
          },
          onClickJumpToTop: () {},
          widget: AppText(
            LocaleKeys.reservations,
            style: googleFont.copyWith(color: colorWhite),
          )),
      backgroundColor: colorBlack30,
      body:
      BlocBuilder(
        bloc: _bloc,
        builder: (c, s) => !isLogin
            ? CheckLogin(
                loginCallBack: () {
                  _bloc.onClickLogin(context);
                },
              )
            :  /*const FeatureUnderWidget()*/
        RefreshIndicator(
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
              ),
      ),
    );
  }

  Widget addWidget(BuildContext context) => Visibility(
        visible: isLogin,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: InkWell(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: Utils.backgroundGradientOrangeButton()),
              width: MediaQuery.of(context).size.width / 2.8,
              height: 37.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    color: colorWhite,
                    size: 18,
                  ),
                  AppText(
                    " ${AppLocalizations.of(context)!.reservations}",
                    style:
                        typoW600.copyWith(color: colorText0, fontSize: 13.sp),
                  )
                ],
              ),
            ),
            onTap: () => _bloc.addOnclick(context),
          ),
        ),
      );

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
          style: typoW600.copyWith(
              fontSize: 10.sp, color: colorText0.withOpacity(0.87)),
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
            top: 10,
            bottom: 10,
            left: contentPadding * 2,
            right: contentPadding * 2),
        height: 72.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: colorBlack90),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: contentPadding + 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: model.isCheck
                        ? LinearGradient(
                            colors: [
                                colorWhite.withOpacity(0.6),
                                colorWhite.withOpacity(0.6)
                              ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)
                        : Utils.backgroundGradientOrangeButton()),
                height: 56.w,
                width: 56.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      Utils.convertDateTimeToEEE(model.calendar),
                      style:
                          typoW600.copyWith(fontSize: 13.sp, color: colorText0),
                    ),
                    AppText(
                      Utils.convertDateTimeToDD(model.calendar),
                      style: typoW600.copyWith(
                          fontSize: 22.sp, color: colorText0, height: 1),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '${model.startTime} - ${model.endTime}',
                    style: typoW600.copyWith(fontSize: 20.sp),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      AppText(
                        ' ${model.status}',
                        style: typoW400.copyWith(
                            fontSize: 12.5.sp,
                            color: colorText0.withOpacity(0.6)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: contentPadding * 5, right: 10),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: colorGrey35,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      Expanded(
                          child: AppText(
                        ' ${model.city}',
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typoW400.copyWith(
                            fontSize: 12.5.sp,
                            color: colorText0.withOpacity(0.6)),
                      ))
                    ],
                  )
                ],
              ))
            ],
          ),
          onTap: () => _bloc.itemOnclick(context, model),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
