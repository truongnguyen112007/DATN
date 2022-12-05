import 'dart:async';

import 'package:base_bloc/components/app_not_data_widget.dart';
import 'package:base_bloc/modules/routes_page/routes_page_cubit.dart';
import 'package:base_bloc/modules/routes_page/routes_page_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:easy_localization/easy_localization.dart';
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
import '../../localization/locale_keys.dart';
import '../../theme/app_styles.dart';
import '../../theme/colors.dart';
import '../../utils/app_utils.dart';
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
        if (event.index == widget.index) _bloc.search(event.key ?? '',1);
      },
    );
    _bloc = RoutesPageCubit();
    paging();
    super.initState();
  }

  @override
  void dispose() {
    _searchEvent?.cancel();
    super.dispose();
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
              child: BlocBuilder<RoutesPageCubit, RoutesPageState>(
                  bloc: _bloc,
                  builder: (c, state) {
                    return (state.status == RouteStatus.search ||
                        state.status == RouteStatus.initial ||
                        state.status == RouteStatus.refresh)
                        ?  const Center(child: AppCircleLoading(),)
                        : state.lRoutes.isEmpty
                            ? Stack(
                                children: [
                                  const Center(child: AppNotDataWidget()),
                                  ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics())
                                ],
                              )
                            : routesWidget(context, state);
                  }),
              onRefresh: () async => _bloc.onRefresh(),
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
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (c, i) => i == state.lRoutes.length
              ? const Center(child: AppCircleLoading())
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
                    LocaleKeys.moveToPlaylist.tr(),
                    ItemAction.MOVE_TO_TOP,
                        () => callBack.call(ItemAction.MOVE_TO_TOP)),
                itemAction(
                    Icons.account_balance_rounded,
                    LocaleKeys.addToPlaylist.tr(),
                    ItemAction.ADD_TO_PLAYLIST,
                        () => callBack.call(ItemAction.ADD_TO_PLAYLIST)),
                itemAction(
                    Icons.add,
                    LocaleKeys.removeFromPlaylist.tr(),
                    ItemAction.REMOVE_FROM_PLAYLIST,
                        () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                itemAction(
                    Icons.favorite,
                    LocaleKeys.addToFavourite.tr(),
                    ItemAction.ADD_TO_FAVOURITE,
                        () => callBack.call(ItemAction.ADD_TO_FAVOURITE)),
                itemAction(
                    Icons.remove_circle_outline,
                    LocaleKeys.removeFromFavorite.tr(),
                    ItemAction.REMOVE_FROM_PLAYLIST,
                        () => callBack.call(ItemAction.REMOVE_FROM_PLAYLIST)),
                itemAction(Icons.share, LocaleKeys.share.tr(),
                    ItemAction.SHARE, () => callBack.call(ItemAction.SHARE)),
                itemAction(Icons.copy, LocaleKeys.copy.tr(),
                    ItemAction.COPY, () => callBack.call(ItemAction.COPY)),
                itemAction(Icons.edit, LocaleKeys.edit.tr(),
                    ItemAction.EDIT, () => callBack.call(ItemAction.EDIT)),
                itemAction(Icons.delete, LocaleKeys.delete.tr(),
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
