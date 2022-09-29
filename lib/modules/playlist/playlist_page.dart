import 'package:base_bloc/components/app_circle_loading.dart';
import 'package:base_bloc/data/globals.dart';
import 'package:base_bloc/modules/playlist/playlist_cubit.dart';
import 'package:base_bloc/modules/playlist/playlist_state.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/item_info_routes.dart';
import '../../data/model/routes_model.dart';
import '../../localizations/app_localazations.dart';
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

  @override
  void initState() {
    _bloc = PlayListCubit();
    paging();
    super.initState();
  }

  void paging() {
    if (scrollController.hasClients) {
      scrollController.addListener(() {
        var maxScroll = scrollController.position.maxScrollExtent;
        var currentScroll = scrollController.position.pixels;
        if (maxScroll - currentScroll <= 200) {
          _bloc.getPlaylist(isPaging: true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            child: BlocBuilder<PlayListCubit, PlaylistState>(
                bloc: _bloc,
                builder: (c, state) {
                  if (state.status == FeedStatus.initial ||
                      state.status == FeedStatus.refresh) {
                    return const Center(
                      child: AppCircleLoading(),
                    );
                  }
                  return playlistWidget(context, state);
                }),
            onRefresh: () async => _bloc.onRefresh()),
        Positioned.fill(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      child: Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                  colors: [colorOrange110, colorOrange100])),
                          child: const Icon(
                            Icons.add,
                            color: colorWhite,
                          )),
                    ))))
      ],
    );
  }

  Widget playlistWidget(BuildContext context, PlaylistState state) =>
      ReorderableListView.builder(
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) newIndex -= 1;
            _bloc.setIndex(newIndex, oldIndex);
          },
          scrollController: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
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
                  onLongPress: (model) => _bloc.itemOnLongClick(context),
                  detailCallBack: (RoutesModel action) =>
                      _bloc.itemOnclick(context,state.lPlayList[i]),
                ),
          itemCount:
              !state.isReadEnd && state.lPlayList.isNotEmpty && state.isLoading
                  ? state.lPlayList.length + 1
                  : state.lPlayList.length);

  @override
  bool get wantKeepAlive => true;
}
