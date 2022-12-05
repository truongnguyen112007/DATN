import 'package:equatable/equatable.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';

class FilterRoutesPageState extends Equatable {
  late FilterParam? filter;
  late List<RoutesModel>? lPlayList;
  final int timeStamp;
  final int currentDesignBy;

  FilterRoutesPageState({
    this.currentDesignBy = 0,
    this.timeStamp = 0,
    this.lPlayList = const <RoutesModel>[],
    this.filter,
  });

  FilterRoutesPageState copyWith(
          {List<RoutesModel>? lPlayList,
          int? currentDesignBy,
          int? currentConnerIndex,
          FilterParam? filter,
          int? timeStamp,
          int? currentStatus}) =>
      FilterRoutesPageState(
          currentDesignBy: currentDesignBy ?? this.currentDesignBy,
          lPlayList: lPlayList ?? this.lPlayList,
          filter: filter ?? this.filter,
          timeStamp: timeStamp ?? this.timeStamp,
         );

  @override
  List<Object?> get props => [
        filter,
        lPlayList,
        timeStamp,
        currentDesignBy,
      ];
}
