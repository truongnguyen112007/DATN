import 'package:equatable/equatable.dart';
import '../../data/model/routes_model.dart';
import '../tab_overview/tab_overview_state.dart';

class AllPageState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;

  const AllPageState(
      {this.status = FeedStatus.initial,
        this.lPlayList = const <RoutesModel>[],
        this.isReadEnd = false,
        this.isLoading = true});

  AllPageState copyWith(
      {FeedStatus? status,
        List<RoutesModel>? lPlayList,
        bool? isReadEnd,
        bool? isLoading}) =>
      AllPageState(
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lPlayList: lPlayList ?? this.lPlayList,
          isReadEnd: isReadEnd ?? this.isReadEnd);

  @override
  List<Object?> get props => [status, lPlayList, isReadEnd,isLoading];
}
