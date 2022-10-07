import 'dart:async';

import 'package:base_bloc/modules/create_routes/create_routes_state.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRoutesCubit extends Cubit<CreateRoutesState> {
  CreateRoutesCubit() : super(const CreateRoutesState()) {
    Timer(const Duration(seconds: 1),
        () => emit(state.copyOf(StatusType.success)));
  }
}
