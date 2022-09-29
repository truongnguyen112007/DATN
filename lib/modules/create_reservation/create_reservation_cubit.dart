import 'package:base_bloc/modules/create_reservation/create_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateReservationCubit extends Cubit<CreateReservationState> {
  CreateReservationCubit() : super(const CreateReservationState());

  void setTime(double startTime, double endTime) =>
      emit(state.copyOf(startTime: startTime, endTime: endTime));
}
