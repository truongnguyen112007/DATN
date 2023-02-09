import 'package:equatable/equatable.dart';

import '../../data/model/routes_model.dart';
import '../tab_home/tab_home_state.dart';

class DesignedState extends Equatable {
  final FeedStatus status;
  final List<RoutesModel> lRoutes;
  final bool isReadEnd;
  final bool isLoading;
  final bool isShowAdd;
  final bool isClickRadioButton;
  final bool isShowActionButton;
  final int timeStamp;
  final int nextPage;

  const DesignedState({
    this.status = FeedStatus.initial,
    this.lRoutes = const <RoutesModel>[],
    this.isReadEnd = false,
    this.timeStamp = 0,
    this.isLoading = true,
    this.isShowAdd = true,
    this.isClickRadioButton = false,
    this.isShowActionButton = false,
    this.nextPage = 1,
  });

  DesignedState copyWith(
          {FeedStatus? status,
          List<RoutesModel>? lRoutes,
          int? timeStamp,
          bool? isReadEnd,
          bool? isLoading,
          bool? isShowAdd,
          bool? isClickRadioButton,
          bool? isShowActionButton,
          int? nextPage}) =>
      DesignedState(
          timeStamp: timeStamp ?? this.timeStamp,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lRoutes: lRoutes ?? this.lRoutes,
          isReadEnd: isReadEnd ?? this.isReadEnd,
          isShowAdd: isShowAdd ?? this.isShowAdd,
          isClickRadioButton: isClickRadioButton ?? this.isClickRadioButton,
          isShowActionButton: isShowActionButton ?? this.isShowActionButton,
          nextPage: nextPage ?? this.nextPage);

  @override
  List<Object?> get props => [
        status,
        lRoutes,
        isReadEnd,
        isLoading,
        isShowAdd,
        isClickRadioButton,
        isShowActionButton,
        timeStamp,
        nextPage,
      ];
}
