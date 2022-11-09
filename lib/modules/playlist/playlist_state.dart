import 'package:base_bloc/data/model/playlist_model.dart';
import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:equatable/equatable.dart';

class PlaylistState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lRoutes;
  final List<PlaylistModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;
  final int? timeStamp;

  PlaylistState(
      {this.status = FeedStatus.initial,
      this.lRoutes = const <RoutesModel>[],
      this.lPlayList = const <PlaylistModel>[],
      this.isReadEnd = false,
      this.isLoading = true,
      this.timeStamp});

  PlaylistState copyWith(
          {FeedStatus? status,
          List<RoutesModel>? lRoutes,
          List<PlaylistModel>? lPlaylist,
          bool? isReadEnd,
          int? timeStamp,
          bool? isLoading}) =>
      PlaylistState(
          timeStamp: timeStamp ?? this.timeStamp,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lRoutes: lRoutes ?? this.lRoutes,
          isReadEnd: isReadEnd ?? this.isReadEnd);

  @override
  List<Object?> get props => [status, lRoutes, isReadEnd,isLoading,timeStamp];
}
