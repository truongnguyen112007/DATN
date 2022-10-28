import 'package:equatable/equatable.dart';

import '../../data/model/routes_model.dart';
import '../tab_home/tab_home_state.dart';

class FavouriteState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;
  final bool isShowAdd;
  final bool isClickRadioButton;
  final bool isShowActionButton;
  final int timeStamp;

  const FavouriteState({
    this.status = FeedStatus.initial,
    this.lPlayList = const <RoutesModel>[],
    this.isReadEnd = false,
    this.timeStamp = 0,
    this.isLoading = true,
    this.isShowAdd = true,
    this.isClickRadioButton = false,
    this.isShowActionButton = false,
  });

  FavouriteState copyWith(
          {FeedStatus? status,
          List<RoutesModel>? lPlayList,
            int? timeStamp,
          bool? isReadEnd,
          bool? isLoading,
          bool? isShowAdd,
          bool? isClickRadioButton,
          bool? isShowActionButton}) =>
      FavouriteState(
          timeStamp: timeStamp ?? this.timeStamp,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lPlayList: lPlayList ?? this.lPlayList,
          isReadEnd: isReadEnd ?? this.isReadEnd,
          isShowAdd: isShowAdd ?? this.isShowAdd,
          isClickRadioButton: isClickRadioButton ?? this.isClickRadioButton,
          isShowActionButton: isShowActionButton ?? this.isShowActionButton);

  @override
  List<Object?> get props =>
      [status, lPlayList, isReadEnd, isLoading, isShowAdd, isClickRadioButton,isShowActionButton];
}
