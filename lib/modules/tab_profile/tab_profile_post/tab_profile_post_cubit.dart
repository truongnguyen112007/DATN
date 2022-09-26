import 'dart:async';
import 'package:base_bloc/modules/tab_profile/tab_profile_post/tab_profile_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/feed_model.dart';
import '../../../gen/assets.gen.dart';

class TabProfilePostCubit extends Cubit<TabProfilePostState> {
  TabProfilePostCubit() : super(const TabProfilePostState(status: ProfilePostStatus.initial)) {
    if (state.status == ProfilePostStatus.initial) {
      getFeed();
    }
  }

  void getFeed({bool isPaging = false}) {
    if (state.readEnd) return;
    if (isPaging) {
      Timer(const Duration(seconds: 1), () {
        emit(state.copyOf(
            lFeed: List.of(state.lFeed)..addAll(fakeData()), readEnd: true));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        emit(TabProfilePostState(
            readEnd: false,
            lFeed: fakeData(),
            status: ProfilePostStatus.success,
            currentPage: 1));
      });
    }
  }

  void refresh() {
    emit(TabProfilePostState(status: ProfilePostStatus.refresh));
    getFeed();
  }

  List<FeedModel> fakeData() => [
    FeedModel(true,
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    FeedModel(false, '', photoURL: Assets.png.test.path),
  ];
}
