import 'dart:async';

import 'package:base_bloc/modules/routers_detail/routes_detail_page.dart';
import 'package:base_bloc/modules/routers_detail/routes_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutesDetailCubit extends Cubit<RoutesDetailState> {
  RoutesDetailCubit() : super(const RoutesDetailState(status: RoutesStatus.initial)) {
    Timer(const Duration(seconds: 1),
        () => emit(state.copyOf(RoutesStatus.success)));
  }

  void handleAction(RoutesAction action) {
    switch (action) {
      case RoutesAction.INFO:
      case RoutesAction.COPY:
      case RoutesAction.SHARE:
      case RoutesAction.ADD_FAVOURITE:
      case RoutesAction.ADD_TO_PLAY_LIST:
    }
  }
}