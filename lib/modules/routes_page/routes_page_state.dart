import 'package:equatable/equatable.dart';
import '../../data/model/routes_model.dart';

enum DesignStatus { initial, success, failure, refresh, search }

class RoutesPageState extends Equatable {
  final DesignStatus status;
  final List<RoutesModel> lRoutes;
  final bool isReadEnd;
  final bool isLoading;
  final int? timeStamp;
  final bool isShowAdd;
  final bool isClickRadioButton;
  final bool isShowActionButton;

  const RoutesPageState({
    this.status = DesignStatus.initial,
    this.lRoutes = const <RoutesModel>[],
    this.isReadEnd = false,
    this.isLoading = true,
    this.timeStamp = 0,
    this.isShowAdd = true,
    this.isClickRadioButton = false,
    this.isShowActionButton = false,
  });

  RoutesPageState copyWith(
          {DesignStatus? status,
          List<RoutesModel>? lRoutes,
          bool? isReadEnd,
          bool? isLoading,
          int? timeStamp,
          bool? isShowAdd,
          bool? isClickRadioButton,
          bool? isShowActionButton}) =>
      RoutesPageState(
          timeStamp: timeStamp,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lRoutes: lRoutes ?? this.lRoutes,
          isReadEnd: isReadEnd ?? this.isReadEnd,
          isShowAdd: isShowAdd ?? this.isShowAdd,
          isClickRadioButton: isClickRadioButton ?? this.isClickRadioButton,
          isShowActionButton: isShowActionButton ?? this.isShowActionButton);

  @override
  List<Object?> get props => [status, lRoutes, isReadEnd, isLoading, timeStamp,isShowAdd, isClickRadioButton,isShowActionButton];
}
