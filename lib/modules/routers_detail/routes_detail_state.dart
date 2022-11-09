import 'package:base_bloc/data/model/routes_model.dart';
import 'package:equatable/equatable.dart';

enum RoutesStatus { initial, success, failure, refresh }

class RoutesDetailState extends Equatable {
  final RoutesStatus status;
  final RoutesModel model;

  const RoutesDetailState(
      {this.status = RoutesStatus.initial, required this.model});

  RoutesDetailState copyOf({RoutesStatus? status, RoutesModel? model}) =>
      RoutesDetailState(
          status: status ?? this.status, model: model ?? this.model);

  @override
  List<Object?> get props => [status];
}
