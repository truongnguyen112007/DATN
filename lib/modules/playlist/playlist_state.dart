import 'package:base_bloc/data/model/playlist_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:equatable/equatable.dart';

class PlaylistState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lRoutes;
  final List<RoutesModel> lRoutesCache;
  final List<PlaylistModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;
  final int? timeStamp;
  final int nextPage;
  final bool isDrag;
  final bool isOverlay;
  final bool isChooseDragDrop;
  late int startIndex;
  late int endIndex;

  PlaylistState(
      {this.status = FeedStatus.initial,
      this.lRoutes = const <RoutesModel>[],
      this.lRoutesCache = const <RoutesModel>[],
      this.lPlayList = const <PlaylistModel>[],
      this.isReadEnd = false,
      this.isLoading = true,
      this.isDrag = false,
      this.isOverlay = false,
      this.nextPage = 1,
      this.timeStamp,
      this.isChooseDragDrop = false,
      this.startIndex = 100000,
      this.endIndex = 0});

  PlaylistState copyWith(
          {FeedStatus? status,
          List<RoutesModel>? lRoutes,
          List<RoutesModel>? lRoutesCache,
          List<PlaylistModel>? lPlaylist,
          bool? isReadEnd,
          bool? isOverlay,
          int? timeStamp,
          int? nextPage,
          bool? isDrag,
          bool? isLoading,
          bool? isChooseDragDrop,
          int? startIndex,
          int? endIndex}) =>
      PlaylistState(
          isOverlay: isOverlay ?? this.isOverlay,
          nextPage: nextPage ?? this.nextPage,
          timeStamp: timeStamp ?? this.timeStamp,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          isDrag: isDrag ?? this.isDrag,
          lRoutes: lRoutes ?? this.lRoutes,
          lRoutesCache: lRoutesCache ?? this.lRoutesCache,
          isReadEnd: isReadEnd ?? this.isReadEnd,
          isChooseDragDrop: isChooseDragDrop ?? this.isChooseDragDrop,
          startIndex: startIndex ?? this.startIndex,
          endIndex: endIndex ?? this.endIndex);

  @override
  List<Object?> get props => [
        status,
        lRoutes,
        isReadEnd,
        isLoading,
        timeStamp,
        isOverlay,
        isChooseDragDrop,
        isDrag,
        startIndex,
        endIndex,
        lRoutesCache
      ];
}
