import 'package:equatable/equatable.dart';
import '../../data/model/routes_model.dart';

enum DesignStatus { initial, success, failure, refresh,search }

class RoutesPageState extends Equatable {
  final DesignStatus status;
  final List<RoutesModel> lRoutes;
  final bool isReadEnd;
  final bool isLoading;
  final int? timeStamp;

  const RoutesPageState({
    this.status = DesignStatus.initial,
    this.lRoutes = const <RoutesModel>[],
    this.isReadEnd = false,
    this.isLoading = true,
    this.timeStamp,
  });

  RoutesPageState copyWith(
      {DesignStatus? status,
        List<RoutesModel>? lRoutes,
        bool? isReadEnd,
        bool? isLoading,
        int? timeStamp}) =>
      RoutesPageState(
        timeStamp: timeStamp,
        isLoading: isLoading ?? this.isLoading,
        status: status ?? this.status,
        lRoutes: lRoutes ?? this.lRoutes,
        isReadEnd: isReadEnd ?? this.isReadEnd,
      );

  @override
  List<Object?> get props => [status, lRoutes, isReadEnd, isLoading,timeStamp];
}