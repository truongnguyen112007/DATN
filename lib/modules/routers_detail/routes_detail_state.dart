import 'package:base_bloc/data/model/routes_model.dart';
import 'package:equatable/equatable.dart';

enum RoutesStatus { initial, success, failure, refresh }

class RoutesDetailState extends Equatable {
  final RoutesStatus status;
  final RoutesModel model;
  final int? timeStamp;
   List<dynamic> lHoldSet;

   RoutesDetailState(
      {this.status = RoutesStatus.initial,
      required this.model,
      this.lHoldSet = const <dynamic>[],
      this.timeStamp});

  RoutesDetailState copyOf(
          {RoutesStatus? status, RoutesModel? model,
          int? timeStamp,
          List<dynamic>? lHoldSet}) =>
      RoutesDetailState(
          lHoldSet: lHoldSet ?? this.lHoldSet,
          timeStamp: timeStamp ?? this.timeStamp,
          status: status ?? this.status,
          model: model ?? this.model);

  @override
  List<Object?> get props => [status, model, timeStamp, lHoldSet];
}
