import 'dart:async';

import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/app_not_data_widget.dart';
import 'package:base_bloc/components/app_text.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/playlist/playlist_cubit.dart';
import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/theme/app_styles.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../components/item_info_routes.dart';
import '../../config/constant.dart';
import '../../data/eventbus/refresh_event.dart';
import '../../data/model/routes_model.dart';
import '../../localization/locale_keys.dart';
import '../../router/router.dart';
import '../../utils/log_utils.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({Key? key}) : super(key: key);

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage>
    with AutomaticKeepAliveClientMixin {
  late PlayListCubit _bloc;
  var scrollController = ScrollController();
  StreamSubscription<RefreshEvent>? _refreshStream;
  var speedDialController = SpeedDialController();

  @override
  void initState() {
    _bloc = PlayListCubit();
    paging();
    _refreshStream = Utils.eventBus.on<RefreshEvent>().listen((event) {
      if (event.type == RefreshType.PLAYLIST) {
        _bloc.onRefresh();
      }
    });
    super.initState();
  }

  void paging() {
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200) {
        _bloc.getPlayListById(isPaging: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            chooseDragDrop(),
            Expanded(
              child: RefreshIndicator(
                child: BlocBuilder<PlayListCubit, PlaylistState>(
                    bloc: _bloc,
                    builder: (c, state) {
                      return state.status == FeedStatus.initial ||
                              state.status == FeedStatus.refresh
                          ? const Center(child: AppCircleLoading())
                          : (state.status == FeedStatus.failure ||
                                  state.lRoutes.isEmpty
                              ? Center(
                                  child: Stack(children: [
                                  ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics()),
                                  const AppNotDataWidget()
                                ]))
                              : playlistWidget(context, state));
                    }),
                onRefresh: () async => _bloc.onRefresh(),
              ),
            ),
          ],
        ),
        overLayWidget(),
        addWidget(context)
      ],
    );
  }

  Widget overLayWidget() => BlocBuilder<PlayListCubit, PlaylistState>(
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

  Widget addWidget(BuildContext context) => Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Align(
            alignment: Alignment.bottomRight,
            child: SpeedDial(
              controller: speedDialController,
              onOpen: () => _bloc.showOverlay(true),
              onClose: () => _bloc.showOverlay(false),
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
              buttonSize: const Size(56.0, 56.0),
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
                  onTap: () => _bloc.searchOnclick(context),
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
      );

  Widget playlistWidget(BuildContext context, PlaylistState state){
   return ReorderableListView.builder(
      scrollController: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      itemBuilder: (c, i) => i == state.lRoutes.length
          ? Center(
        key: Key("$i"),
        child: const AppCircleLoading(),
      )
          : ItemInfoRoutes(
        isDrag: state.isDrag,
        key: Key("$i"),
        context: context,
        model: state.lRoutes[i],
        callBack: (model) {},
        index: i,
        onLongPressCallBack: (model) => _bloc.setDrag(true),
        doubleTapCallBack: (model) =>
            _bloc.itemDoubleClick(context, model, i),
        detailCallBack: (RoutesModel action) =>
            _bloc.itemOnclick(context, state.lRoutes[i]),
      ),
      itemCount:
      !state.isReadEnd && state.lRoutes.isNotEmpty && state.isLoading
          ? state.lRoutes.length + 1
          : state.lRoutes.length,
      onReorder: (int oldIndex, int newIndex) {
        _bloc.dragItem(oldIndex, newIndex);
      },
    );
  }

  Widget chooseDragDrop() {
    return BlocBuilder<PlayListCubit, PlaylistState>(
      bloc: _bloc,
      builder: (c, s) => Visibility(
        visible: s.isChooseDragDrop,
        child: Container(
          height: 30.h,
          color: colorBlack,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _bloc.closeDragDrop(),
                  child: const Icon(
                    Icons.close,
                    color: colorWhite,
                  ),
                ),
                InkWell(
                  onTap: () => _bloc.saveDragDrop(context),
                  child: const Icon(
                    Icons.check,
                    color: colorWhite,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
