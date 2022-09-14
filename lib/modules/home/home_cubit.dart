import 'package:base_bloc/modules/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitState());

  void jumpToPage(int index) => emit(IndexChangeState(index));
}
