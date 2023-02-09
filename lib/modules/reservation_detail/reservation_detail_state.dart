import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:base_bloc/modules/tab_reservation/tab_reservation_state.dart';
import 'package:equatable/equatable.dart';

class ReservationState extends Equatable {
  final StatusType status;
  final ReservationModel? model;

  const ReservationState({this.status = StatusType.initial, this.model});

  @override
  List<Object?> get props => [model, status];
}
