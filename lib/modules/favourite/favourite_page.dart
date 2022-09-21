import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/favourite/favourite_cubit.dart';
import 'package:base_bloc/modules/favourite/favourite_state.dart';
import 'package:base_bloc/modules/playlist/playlist_cubit.dart';
import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/filter_widget.dart';
import '../../components/item_info_routes.dart';
import '../../data/model/routes_model.dart';
import '../../theme/colors.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with AutomaticKeepAliveClientMixin {
  late FavouriteCubit _bloc;
  var scrollController = ScrollController();

  @override
  void initState() {
    _bloc = FavouriteCubit();
    paging();
    super.initState();
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
    return RefreshIndicator(
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                FilterWidget(
                  isSelect: true,
                  selectCallBack: () {},
                  filterCallBack: () => _bloc.filterOnclick(context),
                  sortCallBack: () {},
                ),
                BlocBuilder<FavouriteCubit, FavouriteState>(
                    bloc: _bloc,
                    builder: (c, state) {
                      if (state.status == FeedStatus.initial ||
                          state.status == FeedStatus.refresh) {
                        return const SizedBox();
                      }
                      return playlistWidget(context, state);
                    })
              ],
            ),
          ),
          BlocBuilder<FavouriteCubit, FavouriteState>(
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
    );
  }

  List<String> test() => ['a', 'b', 'c', 'd'];

  Widget playlistWidget(BuildContext context, FavouriteState state) =>
      ReorderableListView.builder(
          shrinkWrap: true,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) newIndex -= 1;
            _bloc.setIndex(newIndex, oldIndex);
          },
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(contentPadding),
          itemBuilder: (c, i) => i == state.lPlayList.length
              ? const Center(
                  key: Key('9182098089509'),
                  child: AppCircleLoading(),
                )
              : ItemInfoRoutes(
                  key: Key('$i'),
                  context: context,
                  model: state.lPlayList[i],
                  callBack: (model) {},
                  index: i,
                  onLongPress: (model) => _bloc.itemOnClick(context),
                  detailCallBack: (RoutesModel action) {},
                ),
          itemCount:
              !state.isReadEnd && state.lPlayList.isNotEmpty && state.isLoading
                  ? state.lPlayList.length + 1
                  : state.lPlayList.length);

  @override
  bool get wantKeepAlive => true;
}
