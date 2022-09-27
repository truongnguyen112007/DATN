import 'package:base_bloc/base/base_state.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_post/tab_profile_post_cubit.dart';
import 'package:base_bloc/modules/tab_profile/tab_profile_post/tab_profile_post_state.dart';
import 'package:base_bloc/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_scalford.dart';
import '../../../components/item_feed_widget.dart';
import '../../../config/constant.dart';

class TabProfilePost extends StatefulWidget {
  const TabProfilePost({Key? key}) : super(key: key);

  @override
  State<TabProfilePost> createState() => _TabProfilePostState();
}

class _TabProfilePostState extends BaseState<TabProfilePost>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late final TabProfilePostCubit _bloc;

  @override
  void initState() {
    _bloc = TabProfilePostCubit();
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
    if(_scrollController.hasClients) {
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
        backgroundColor: colorBlack20,
        body: RefreshIndicator(
          child: feedWidget(),
          onRefresh: () async => _bloc.refresh(),
        ));
  }

  Widget feedWidget() => BlocBuilder<TabProfilePostCubit, TabProfilePostState>(
    bloc: _bloc,
    builder: (BuildContext context, state) {
      Widget? widget;
      if (state.status == ProfilePostStatus.initial ||
          state.status == ProfilePostStatus.refresh) {
        widget = const SizedBox();
      } else if (state.status == ProfilePostStatus.success) {
        widget = ListView.separated(
          primary: true,
          itemBuilder: (BuildContext context, int index) =>
          (index == state.lFeed.length)
              ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ))
              : ItemFeed(
            model: state.lFeed[index],
            index: BottomNavigationConstant.TAB_HOME,
          ),
          itemCount:
          !state.readEnd ? state.lFeed.length + 1 : state.lFeed.length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(
            height: 1,
          ),
        );
      }
      return widget ?? const Text('TRUG');
    },
  );

  @override
  bool get wantKeepAlive => true;

}