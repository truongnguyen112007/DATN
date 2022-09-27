import 'package:base_bloc/modules/reservation_detail/reservation_detail_state.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationDetailCubit extends Cubit<ReservationState> {
  ReservationDetailCubit() : super(const ReservationState()) {}

  void cancelOnClick(BuildContext context) =>
      logE("TAG cancelOnClickcancelOnClick");
}
