import 'dart:async';

import 'package:base_bloc/modules/routes_page/routes_page_cubit.dart';
import 'package:base_bloc/modules/routes_page/routes_page_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_circle_loading.dart';
import '../../components/app_text.dart';
import '../../components/filter_widget.dart';
import '../../components/gradient_button.dart';
import '../../components/item_info_routes.dart';
import '../../data/eventbus/search_home_event.dart';
import '../../data/globals.dart';
import '../../data/model/routes_model.dart';
import '../../localizations/app_localazations.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';
import '../../utils/log_utils.dart';
import '../playlist/playlist_cubit.dart';
import '../tab_home/tab_home_state.dart';

class RoutesPage extends StatefulWidget {
  final int index;

  const RoutesPage({Key? key, required this.index}) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage>
    with AutomaticKeepAliveClientMixin {
  String? keySearch = '';
  late RoutesPageCubit _bloc;
  var scrollController = ScrollController();
  StreamSubscription<SearchHomeEvent>? _searchEvent;

  @override
  void initState() {
    _searchEvent = Utils.eventBus.on<SearchHomeEvent>().listen(
      (event) {
        if (event.index == widget.index) {
          keySearch = event.key;
          _bloc.search(keySearch!);
        }
      },
    );
    _bloc = RoutesPageCubit();
    paging();
    super.initState();
  }

  void paging() {
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200) {
        _bloc.getRoutes(isPaging: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorGreyBackground,
      child: Column(
        children: [
          FilterWidget(
            isSelect: true,
            selectCallBack: () => _bloc.selectOnclick(false),
            filterCallBack: () => _bloc.filterOnclick(context),
            sortCallBack: () {},
            unsSelectCallBack: () => _bloc.selectOnclick(true),
          ),
          Expanded(
            child: RefreshIndicator(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        BlocBuilder<RoutesPageCubit, RoutesPageState>(
                            bloc: _bloc,
                            builder: (c, state) {
                              if (state.status == FeedStatus.initial ||
                                  state.status == FeedStatus.refresh) {
                                return const SizedBox();
                              } else if (state.status == DesignStatus.search) {}
                              return routesWidget(context, state);
                            }),
                      ],
                    ),
                  ),
                  BlocBuilder<RoutesPageCubit, RoutesPageState>(
                    bloc: _bloc,
                    builder: (BuildContext context, state) =>
                        (state.status == FeedStatus.initial ||
                                state.status == FeedStatus.refresh)
                            ? const Center(
                                child: AppCircleLoading(),
                              )
                            : const SizedBox(),
                  ),
                  BlocBuilder<RoutesPageCubit, RoutesPageState>(
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
                            gradient:
                            Utils.backgroundGradientOrangeButton(),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          onTap: () {
                            var lSelectRadioButton = <RoutesModel>[];
                            for( var element in state.lRoutes) {
                              if (element.isSelect == true) lSelectRadioButton.add(element);
                            }
                            return showActionDialog(
                                lSelectRadioButton, (p0) {});
                          },
                          widget: AppText(
                            'Action',
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
              onRefresh: () async => _bloc.refresh(),
            ),
          ),
        ],
      ),
    );
  }

  Widget routesWidget(BuildContext context, RoutesPageState state) =>
      ListView.builder(
          padding: EdgeInsets.only(
              top: 10.h, left: contentPadding, right: contentPadding),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (c, i) => i == state.lRoutes.length
              ? const Center(
                  child: AppCircleLoading(),
                )
              : ItemInfoRoutes(
                  isShowSelect: !state.isShowAdd,
                  key: Key('$i'),
                  context: context,
                  model: state.lRoutes[i],
                  callBack: (model) {},
                  index: i,
                  onLongPress: (model) {
                    _bloc.itemOnLongPress(context);
                  },
                  filterOnclick: () {
                    _bloc.filterItemOnclick(i);
                  },
                  detailCallBack: (RoutesModel action) {
                    _bloc.itemOnclick(context, state.lRoutes[i]);
                  },
                ),
          itemCount:
              !state.isReadEnd && state.lRoutes.isNotEmpty && state.isLoading
                  ? state.lRoutes.length + 1
                  : state.lRoutes.length);

  void showActionDialog(
      List<RoutesModel> model, Function(ItemAction) callBack) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (x) => Wrap(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF212121),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: contentPadding,
                ),
                itemAction(
                    Icons.thumb_up_alt,
                    LocaleKeys.moveToPlaylist,
                    ItemAction.MOVE_TO_TOP,
                        () => callBack.call(ItemAction.MOVE_TO_TOP)),
                itemAction(
                    Icons.account_balance_rounded,
                    LocaleKeys.addToPlaylist,
                    ItemAction.ADD_TO_PLAYLIST,
                        () => callBack.call(ItemAction.ADD_TO_PLAYLIST)),
                itemAction(
                    Icons.add,
                    LocaleKeys.removeFromPlaylist,
                    ItemAction.REMOVE_FROM_PLAYLIST,
                        () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                itemAction(
                    Icons.favorite,
                    LocaleKeys.addToFavourite,
                    ItemAction.ADD_TO_FAVOURITE,
                        () => callBack.call(ItemAction.ADD_TO_FAVOURITE)),
                itemAction(
                    Icons.remove_circle_outline,
                    LocaleKeys.removeFromFavorite,
                    ItemAction.REMOVE_FROM_PLAYLIST,
                        () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                itemAction(Icons.share, LocaleKeys.share,
                    ItemAction.SHARE, () => callBack.call(ItemAction.SHARE)),
                itemAction(Icons.copy, LocaleKeys.copy,
                    ItemAction.COPY, () => callBack.call(ItemAction.COPY)),
                itemAction(Icons.edit, LocaleKeys.edit,
                    ItemAction.EDIT, () => callBack.call(ItemAction.EDIT)),
                itemAction(Icons.delete, LocaleKeys.delete,
                    ItemAction.DELETE, () => callBack.call(ItemAction.DELETE)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget itemAction(IconData icon, String text, ItemAction action,
      VoidCallback filterCallBack) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 40.w,
            ),
            AppText(
              text,
              style: typoSuperSmallTextRegular.copyWith(color: colorText0),
            )
          ],
        ),
      ),
      onTap: () => filterCallBack.call(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
