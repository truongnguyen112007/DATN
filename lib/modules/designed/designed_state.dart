import 'package:equatable/equatable.dart';

import '../../data/model/routes_model.dart';

enum DesignStatus { initial, success, failure, refresh }

class DesignedState extends Equatable {
  final DesignStatus status;
  final List<RoutesModel> lRoutes;
  final bool isReadEnd;
  final bool isLoading;
  final int? timeStamp;

  const DesignedState({
    this.status = DesignStatus.initial,
    this.lRoutes = const <RoutesModel>[],
    this.isReadEnd = false,
    this.isLoading = true,
    this.timeStamp,
  });

  DesignedState copyWith(
          {DesignStatus? status,
          List<RoutesModel>? lRoutes,
          bool? isReadEnd,
          bool? isLoading,
            int? timeStamp}) =>
      DesignedState(
        timeStamp: timeStamp,
        isLoading: isLoading ?? this.isLoading,
        status: status ?? this.status,
        lRoutes: lRoutes ?? this.lRoutes,
        isReadEnd: isReadEnd ?? this.isReadEnd,
      );

  @override
  List<Object?> get props => [status, lRoutes, isReadEnd, isLoading,timeStamp];
}
