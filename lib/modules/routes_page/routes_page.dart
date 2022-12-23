import 'dart:async';

import 'package:base_bloc/components/app_not_data_widget.dart';
import 'package:base_bloc/components/app_scalford.dart';
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
import '../../data/eventbus/refresh_event.dart';
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
  var filterController = FilterController();
  StreamSubscription<SearchHomeEvent>? _searchEvent;

  @override
  void initState() {
    _searchEvent = Utils.eventBus.on<SearchHomeEvent>().listen(
          (event) {
        if (event.index == widget.index) _bloc.setKeySearch(event.key ?? '');
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
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorGreyBackground,
      body:
      Stack(
        children: [
          Column(
            children: [
              FilterWidget(
                filterController: filterController,
                isSelect: true,
                selectCallBack: () => _bloc.selectOnclick(false),
                filterCallBack: () => _bloc.filterOnclick(context),
                sortCallBack: () => _bloc.sortOnclick(context),
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
                            : (state.status == FeedStatus.failure || state.lRoutes.isEmpty
                            ? Stack(
                          children: [
                            const Center(child: AppNotDataWidget()),
                            ListView(
                                physics:
                                const AlwaysScrollableScrollPhysics())
                          ],
                        )
                            : routesWidget(context, state));
                      }),
                  onRefresh: () async => _bloc.onRefresh(),
                ),
              ),
            ],
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
                    gradient: Utils.backgroundGradientOrangeButton(),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onTap: () {
                    var lSelectRadioButton = <RoutesModel>[];
                    for (var element in state.lRoutes) {
                      if (element.isSelect == true)
                        lSelectRadioButton.add(element);
                    }
                    _bloc.itemOnDoubleClick(
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

  Widget routesWidget(BuildContext context, RoutesPageState state) =>
      ListView.builder(
        controller: scrollController,
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
            doubleTapCallBack: (model) {
                    !isLogin
                        ? _bloc.none()
                        : _bloc.itemOnDoubleClick(context, i, filterController,
                            model: model);
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
