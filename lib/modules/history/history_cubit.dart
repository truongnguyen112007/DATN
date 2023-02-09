import 'dart:async';

import 'package:base_bloc/config/constant.dart';
import 'package:base_bloc/modules/filter_routes/filter_routes_page.dart';
import 'package:base_bloc/modules/history/history_state.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/feed_model.dart';
import '../../gen/assets.gen.dart';
import '../tab_home/tab_home_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState(status: FeedStatus.initial)) {
    if (state.status == FeedStatus.initial) {
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
        emit(HistoryState(
            readEnd: false,
            lFeed: fakeData(),
            status: FeedStatus.success,
            currentPage: 1));
      });
    }
  }

  void refresh() {
    emit(const HistoryState(status: FeedStatus.refresh));
    getFeed();
  }

  List<FeedModel> fakeData() => [
        FeedModel(true,
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
        FeedModel(false, '', photoURL: Assets.png.test.path),
      ];

  void filterOnclick(BuildContext context) => RouterUtils.openNewPage(
      FilterRoutesPage(
        showResultButton: (model) {},  removeFilterCallBack: (model) {},
      ),
      context);
}
