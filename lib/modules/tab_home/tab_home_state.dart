import 'package:equatable/equatable.dart';
import '../../data/model/feed_model.dart';

enum FeedStatus { initial, success, failure, refresh }

class TabHomeState extends Equatable {
  final List<FeedModel> lFeed;
  final bool readEnd;
  final int currentPage;
  final FeedStatus status;
  final int? timeStamp;
  const TabHomeState(
      {this.readEnd = false,
        this.timeStamp,
      this.currentPage = 1,
      this.lFeed = const <FeedModel>[],
      this.status = FeedStatus.initial,});

  @override
  List<Object?> get props => [lFeed, readEnd, currentPage,timeStamp];

  @override
  String toString() {
    return "TAB HOME STATE: lFeed readEnd currentPage";
  }

  TabHomeState copyOf(
          {List<FeedModel>? lFeed,
          bool? readEnd,
          int? currentPage,
          int? timeStamp,
          FeedStatus? status,
          bool? isAddToPlayList}) =>
      TabHomeState(
          lFeed: lFeed ?? this.lFeed,
          readEnd: readEnd ?? this.readEnd,
          currentPage: currentPage ?? this.currentPage,
          status: status ?? this.status,
          timeStamp: timeStamp ?? this.timeStamp,
         );
}
