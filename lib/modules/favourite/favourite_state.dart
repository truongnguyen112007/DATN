
import 'package:equatable/equatable.dart';

import '../../data/model/routes_model.dart';
import '../tab_home/tab_home_state.dart';

class FavouriteState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;

  const FavouriteState(
      {this.status = FeedStatus.initial,
        this.lPlayList = const <RoutesModel>[],
        this.isReadEnd = false,
        this.isLoading = true});

  FavouriteState copyWith(
      {FeedStatus? status,
        List<RoutesModel>? lPlayList,
        bool? isReadEnd,
        bool? isLoading}) =>
      FavouriteState(
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lPlayList: lPlayList ?? this.lPlayList,
          isReadEnd: isReadEnd ?? this.isReadEnd);

  @override
  List<Object?> get props => [status, lPlayList, isReadEnd,isLoading];
}
