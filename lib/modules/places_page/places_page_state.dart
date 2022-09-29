import 'package:equatable/equatable.dart';
import '../../data/model/list_places_model.dart';
import '../tab_home/tab_home_state.dart';

class PlacesPageState extends Equatable {
  final FeedStatus status;
  final List<PlacesModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;

  const PlacesPageState(
      {this.status = FeedStatus.initial,
        this.lPlayList = const <PlacesModel>[],
        this.isReadEnd = false,
        this.isLoading = true});

  PlacesPageState copyWith(
      {FeedStatus? status,
        List<PlacesModel>? lPlayList,
        bool? isReadEnd,
        bool? isLoading}) =>
      PlacesPageState(
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lPlayList: lPlayList ?? this.lPlayList,
          isReadEnd: isReadEnd ?? this.isReadEnd);

  @override
  List<Object?> get props => [status, lPlayList, isReadEnd,isLoading];
}