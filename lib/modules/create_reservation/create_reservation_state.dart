import 'package:equatable/equatable.dart';

class CreateReservationState extends Equatable {
  final double startTime;
  final double endTime;

  const CreateReservationState({this.startTime = 6, this.endTime = 15});

  CreateReservationState copyOf({double? startTime, double? endTime}) =>
      CreateReservationState(
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime);

  @override
  List<Object?> get props => [startTime,endTime];
}
