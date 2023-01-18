import 'dart:async';

import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_scalford.dart';
import 'package:base_bloc/components/gradient_button.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/favourite/favourite_cubit.dart';
import 'package:base_bloc/modules/favourite/favourite_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../components/app_not_data_widget.dart';
import '../../components/app_text.dart';
import '../../components/filter_widget.dart';
import '../../components/item_info_routes.dart';
import '../../data/eventbus/refresh_event.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../playlist/playlist_cubit.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key,}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with AutomaticKeepAliveClientMixin {
  late FavouriteCubit _bloc;
  var scrollController = ScrollController();
  var filterController = FilterController();
  StreamSubscription<RefreshEvent>? _refreshStream;
  var speedDialController = SpeedDialController();

  @override
  void initState() {
    _bloc = FavouriteCubit();
    paging();
    _refreshStream = Utils.eventBus.on<RefreshEvent>().listen((model) {
      if (model.type == RefreshType.FAVORITE) {
        _bloc.refresh();
      }
    });
    super.initState();
  }

  void paging() {
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200) {
        _bloc.getFavourite(isPaging: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: colorGreyBackground,
      body: Stack(
        children: [
          Column(
            children: [
              FilterWidget(
                filterController: filterController,
                isSelect: true,
                selectCallBack: () {
                  _bloc.selectOnclick(false);
                },
                filterCallBack: () => _bloc.filterOnclick(context),
                sortCallBack: () => _bloc.sortOnclick(context),
                unsSelectCallBack: () {
                  _bloc.selectOnclick(true);
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  child: BlocBuilder<FavouriteCubit, FavouriteState>(
                      bloc: _bloc,
                      builder: (c, state) {
                        return (state.status == FeedStatus.initial ||
                            state.status == FeedStatus.refresh)
                            ? const Center(child: AppCircleLoading())
                            : (state.status == FeedStatus.failure ||
                            state.lPlayList.isEmpty
                            ? Center(
                            child: Stack(children: [
                              ListView(
                                physics:
                                const AlwaysScrollableScrollPhysics(),
                              ),
                              const AppNotDataWidget()
                            ]))
                            : playlistWidget(context, state));
                      }),
                  onRefresh: () async => _bloc.refresh(),
                ),
              ),
            ],
          ),
          overLayWidget(),
          addWidget(context),
          BlocBuilder<FavouriteCubit, FavouriteState>(
            bloc: _bloc,
            builder: (c, state) => Positioned.fill(
              left: 10.w,
              bottom: 10.h,
              right: 5.w,
              child: state.isShowActionButton
                  ? Align(
                alignment: Alignment.bottomRight,
                child: GradientButton(
                  height: 36.h,
                  isCenter: true,
                  width: 170.w,
                  decoration: BoxDecoration(
                    gradient: Utils.backgroundGradientOrangeButton(),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onTap: () {
                    _bloc.doubleOnClick(
                        context,0,filterController,
                        isMultiSelect: true);
                  },
                  widget: AppText(
                    LocaleKeys.action.tr(),
                    style: googleFont.copyWith(
                        color: colorWhite, fontSize: 15.sp),
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
              )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget overLayWidget() => BlocBuilder<FavouriteCubit, FavouriteState>(
      bloc: _bloc,
      builder: (c, state) => state.isOverlay
          ? InkWell(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: colorBlack.withOpacity(0.8)),
        onTap: () {
          speedDialController.setToggle = true;
          _bloc.showOverlay(false);
        },
      )
          : const SizedBox());

  Widget addWidget(BuildContext context) =>
      BlocBuilder<FavouriteCubit, FavouriteState>(
        bloc: _bloc,
        builder: (c, state) => Visibility(
          visible: state.isShowAdd,
          child: Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SpeedDial(
                  onOpen: () => _bloc.showOverlay(true),
                  onClose: () => _bloc.showOverlay(false),
                  controller: speedDialController,
                  overlayColor: colorBlack,
                  overlayOpacity: 0.8,
                  gradientBoxShape: BoxShape.circle,
                  gradient: Utils.backgroundGradientOrangeButton(),
                  icon: Icons.add,
                  backgroundColor: colorOrange100,
                  activeBackgroundColor: colorWhite,
                  activeIcon: Icons.close,
                  activeChild: const Icon(
                    Icons.close,
                    color: colorBlack,
                  ),
                  spacing: 3,
                  childPadding: const EdgeInsets.all(5),
                  spaceBetweenChildren: 4,
                  dialRoot: null,
                  buttonSize: const Size(62.0, 62.0),
                  childrenButtonSize: const Size(56.0, 56.0),
                  direction: SpeedDialDirection.up,
                  renderOverlay: false,
                  useRotationAnimation: true,
                  animationCurve: Curves.elasticInOut,
                  isOpenOnStart: false,
                  animationDuration: const Duration(milliseconds: 300),
                  children: [
                    SpeedDialChild(
                      labelWidget: AppText(
                        LocaleKeys.find_routes.tr(),
                        style: typoW400.copyWith(
                            fontSize: 16, color: colorText0.withOpacity(0.87)),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: colorBlack,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      onTap: () {
                        _bloc.searchOnclick(context);
                      },
                    ),
                    SpeedDialChild(
                      labelWidget: AppText(
                        LocaleKeys.create_routes.tr(),
                        style: typoW400.copyWith(
                            fontSize: 16, color: colorText0.withOpacity(0.87)),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: colorBlack,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      onTap: () => _bloc.createRoutesOnClick(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget playlistWidget(BuildContext context, FavouriteState state) =>
      ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          padding: EdgeInsets.all(contentPadding),
          itemBuilder: (c, i) => i == state.lPlayList.length
              ? const Center(
            child: AppCircleLoading(),
          )
              : ItemInfoRoutes(
            isShowSelect: !state.isShowAdd,
            key: Key('$i'),
            context: context,
            model: state.lPlayList[i],
            callBack: (model) {},
            filterOnclick: () {
              _bloc.filterItemOnclick(i);
            },
            index: i,
            doubleTapCallBack: (model){
                    int count = 0;
                    for (var element in state.lPlayList) {
                      if (element.isSelect == true) {
                        count++;
                      }
                    }
                    if (count <=1) {
                      _bloc.doubleOnClick(context, i, filterController,
                          model: model);
                    } else {
                      _bloc.doubleOnClick(context, 0, filterController,
                          isMultiSelect: true);
                    }
                  },
                  detailCallBack: (RoutesModel action) =>
                _bloc.itemOnclick(context, state.lPlayList[i]),
          ),
          itemCount:
          !state.isReadEnd && state.lPlayList.isNotEmpty && state.isLoading
              ? state.lPlayList.length + 1
              : state.lPlayList.length);

  @override
  bool get wantKeepAlive => true;
}
