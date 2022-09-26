import 'package:base_bloc/modules/routes_page/routes_page_cubit.dart';
import 'package:base_bloc/modules/routes_page/routes_page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/app_circle_loading.dart';
import '../../components/filter_widget.dart';
import '../../components/item_info_routes.dart';
import '../../data/globals.dart';
import '../../data/model/routes_model.dart';
import '../../theme/colors.dart';
import '../tab_home/tab_home_state.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({Key? key}) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage>
    with AutomaticKeepAliveClientMixin {
  late RoutesPageCubit _bloc;
  var scrollController = ScrollController();

  @override
  void initState() {
    _bloc = RoutesPageCubit();
    paging();
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
    return Column(
        children: [
          FilterWidget(
            isSelect: true,
            selectCallBack: () => _bloc.selectOnClick(context),
            filterCallBack: () => _bloc.filterOnclick(context),
            sortCallBack: () {},
          ),
          Expanded(
            child: RefreshIndicator(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        BlocBuilder<RoutesPageCubit, RoutesPageState>(
                            bloc: _bloc,
                            builder: (c, state) {
                              if (state.status == FeedStatus.initial ||
                                  state.status == FeedStatus.refresh) {
                                return const SizedBox();
                              }
                              return routesWidget(context, state);
                            })
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
                  )
                ],
              ),
              onRefresh: () async => _bloc.refresh(),
            ),
          ),
        ],
    );
  }

  List<String> test() => ['a', 'b', 'c', 'd'];

  Widget routesWidget(BuildContext context, RoutesPageState state) =>
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
          // padding: EdgeInsets.all(contentPadding),
          shrinkWrap: true,
          itemBuilder: (c, i) => i == state.lRoutes.length
              ? const Center(
                  key: Key('9182098089509'),
                  child: AppCircleLoading(),
                )
              : ItemInfoRoutes(
                  key: Key('$i'),
                  context: context,
                  model: state.lRoutes[i],
                  callBack: (model) {},
                  index: i,
                  removeSelectCallBack: (model) => _bloc.selectRoutes(i, false),
                  onLongPress: (model) => _bloc.selectRoutes(i, true),
                  detailCallBack: (RoutesModel action) {},
                ),
          itemCount:
              !state.isReadEnd && state.lRoutes.isNotEmpty && state.isLoading
                  ? state.lRoutes.length + 1
                  : state.lRoutes.length);

  @override
  bool get wantKeepAlive => true;
}
