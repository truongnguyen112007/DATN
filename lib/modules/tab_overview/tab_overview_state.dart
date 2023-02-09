import 'package:equatable/equatable.dart';
import '../../data/model/calender_param.dart';
import '../../data/model/feed_model.dart';

enum FeedStatus { initial, success, failure, refresh }

class TabOverViewState extends Equatable {
   CalenderParam? calender;
  final List<FeedModel> lFeed;
  final bool readEnd;
  final int currentPage;
  final FeedStatus status;
  final int? timeStamp;

   TabOverViewState({
    this.calender ,
    this.readEnd = false,
    this.timeStamp,
    this.currentPage = 1,
    this.lFeed = const <FeedModel>[],
    this.status = FeedStatus.initial,
  });

  @override
  List<Object?> get props => [lFeed, readEnd, currentPage, timeStamp, calender];

  @override
  String toString() {
    return "TAB HOME STATE: lFeed readEnd currentPage";
  }

  TabOverViewState copyOf(
          {CalenderParam? calender,
          List<FeedModel>? lFeed,
          bool? readEnd,
          int? currentPage,
          int? timeStamp,
          FeedStatus? status,
          bool? isAddToPlayList}) =>
      TabOverViewState(
        calender: calender ?? this.calender,
        lFeed: lFeed ?? this.lFeed,
        readEnd: readEnd ?? this.readEnd,
        currentPage: currentPage ?? this.currentPage,
        status: status ?? this.status,
        timeStamp: timeStamp ?? this.timeStamp,
      );
}
