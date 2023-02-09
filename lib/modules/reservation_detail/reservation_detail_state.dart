import 'package:base_bloc/data/model/reservation_model.dart';
import 'package:equatable/equatable.dart';
import '../persons_page/persons_page_state.dart';

class ReservationState extends Equatable {
  final StatusType status;
  final ReservationModel? model;

  const ReservationState({this.status = StatusType.initial, this.model});

  @override
  List<Object?> get props => [model, status];
}
