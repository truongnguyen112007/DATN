import 'package:base_bloc/data/model/playlist_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:equatable/equatable.dart';

import '../tab_overview/tab_overview_state.dart';

class PlaylistState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lRoutes;
  final List<PlaylistModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;
  final int? timeStamp;
  final int nextPage;

  PlaylistState(
      {this.status = FeedStatus.initial,
      this.lRoutes = const <RoutesModel>[],
      this.lPlayList = const <PlaylistModel>[],
      this.isReadEnd = false,
      this.isLoading = true,
      this.nextPage = 1,
      this.timeStamp});

  PlaylistState copyWith(
          {FeedStatus? status,
          List<RoutesModel>? lRoutes,
          List<PlaylistModel>? lPlaylist,
          bool? isReadEnd,
          int? timeStamp,
          int? nextPage,
          bool? isLoading}) =>
      PlaylistState(
          nextPage: nextPage ?? this.nextPage,
          timeStamp: timeStamp ?? this.timeStamp,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lRoutes: lRoutes ?? this.lRoutes,
          isReadEnd: isReadEnd ?? this.isReadEnd);

  @override
  List<Object?> get props => [status, lRoutes, isReadEnd,isLoading,timeStamp];
}
