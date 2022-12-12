import 'package:equatable/equatable.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';
import 'filter_routes_page.dart';

class FilterRoutesPageState extends Equatable {
  late FilterParam? filter;
  late List<RoutesModel>? lPlayList;
  final int timeStamp;

  FilterRoutesPageState({
    this.timeStamp = 0,
    this.lPlayList = const <RoutesModel>[],
    this.filter,
  });

  FilterRoutesPageState copyWith(
          {List<RoutesModel>? lPlayList,
          FilterParam? filter,
          int? timeStamp,
         }) =>
      FilterRoutesPageState(
          lPlayList: lPlayList ?? this.lPlayList,
          filter: filter ?? this.filter,
          timeStamp: timeStamp ?? this.timeStamp,
         );

  @override
  List<Object?> get props => [
        filter,
        lPlayList,
        timeStamp,
      ];
}
