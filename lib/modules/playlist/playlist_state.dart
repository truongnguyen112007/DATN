import 'package:base_bloc/data/model/routes_model.dart';
import 'package:base_bloc/modules/tab_home/tab_home_state.dart';
import 'package:equatable/equatable.dart';

class PlaylistState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;

  const PlaylistState(
      {this.status = FeedStatus.initial,
      this.lPlayList = const <RoutesModel>[],
      this.isReadEnd = false,
      this.isLoading = true});

  PlaylistState copyWith(
          {FeedStatus? status,
          List<RoutesModel>? lPlayList,
          bool? isReadEnd,
          bool? isLoading}) =>
      PlaylistState(
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lPlayList: lPlayList ?? this.lPlayList,
          isReadEnd: isReadEnd ?? this.isReadEnd);

  @override
  List<Object?> get props => [status, lPlayList, isReadEnd,isLoading];
}
