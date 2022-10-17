import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/components/message_tab_routes.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/designed/designed_cubit.dart';
import 'package:base_bloc/modules/designed/designed_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/filter_widget.dart';
import '../../components/item_info_routes.dart';
import '../../components/message_search.dart';
import '../../data/model/routes_model.dart';

class DesignedPage extends StatefulWidget {
  const DesignedPage({Key? key}) : super(key: key);

  @override
  State<DesignedPage> createState() => _DesignedPageState();
}

class _DesignedPageState extends State<DesignedPage>
    with AutomaticKeepAliveClientMixin {
  late DesignedCubit _bloc;
  var scrollController = ScrollController();

  @override
  void initState() {
    _bloc = DesignedCubit();
    paging();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    scrollController.dispose();
    super.dispose();
  }

  void paging() {
    if (scrollController.hasClients) {
      scrollController.addListener(() {
        var maxScroll = scrollController.position.maxScrollExtent;
        var currentScroll = scrollController.position.pixels;
        if (maxScroll - currentScroll <= 200) {
          _bloc.getFavourite(isPaging: true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorGreyBackground,
      child: const MessageTabRoutes(),
    );
    //   RefreshIndicator(
    //   child: Stack(
    //     children: [
    //       SingleChildScrollView(
    //         controller: scrollController,
    //         physics: const AlwaysScrollableScrollPhysics(),
    //         child: Column(
    //           children: [
    //             FilterWidget(
    //               isSelect: true,
    //               selectCallBack: () => _bloc.selectOnClick(context),
    //               filterCallBack: () => _bloc.filterOnclick(context),
    //               sortCallBack: () {},
    //             ),
    //             BlocBuilder<DesignedCubit, DesignedState>(
    //                 bloc: _bloc,
    //                 builder: (c, state) {
    //                   if (state.status == FeedStatus.initial ||
    //                       state.status == FeedStatus.refresh) {
    //                     return const SizedBox();
    //                   }
    //                   return routesWidget(context, state);
    //                 })
    //           ],
    //         ),
    //       ),
    //       BlocBuilder<DesignedCubit, DesignedState>(
    //         bloc: _bloc,
    //         builder: (BuildContext context, state) =>
    //             (state.status == FeedStatus.initial ||
    //                     state.status == FeedStatus.refresh)
    //                 ? const Center(
    //                     child: AppCircleLoading(),
    //                   )
    //                 : const SizedBox(),
    //       )
    //     ],
    //   ),
    //   onRefresh: () async => _bloc.refresh(),
    // );
  }

  List<String> test() => ['a', 'b', 'c', 'd'];

  Widget routesWidget(BuildContext context, DesignedState state) =>
      ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(contentPadding),
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
